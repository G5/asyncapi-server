require "spec_helper"

module Asyncapi
  module Server
    describe JobWorker do

      it "does not retry" do
        expect(described_class.sidekiq_options_hash['retry']).to be false
      end

      describe "#perform" do
        it "sends :call to the job's runner class and reports with successful status" do
          job = create(:asyncapi_server_job, {
            class_name: "Runner",
            params: {some: "params"}.to_json,
            callback_url: "client_job_url",
            secret: "sekret",
          })

          expect(Runner).to receive(:call).
            with(job.params) { "message" }
          expect(JobStatusNotifierWorker).to receive(:perform_async).with(job.id, "message")

          described_class.new.perform(job.id)
          job.reload
          expect(job.status).to eq "success"
        end

        context "an error occurred" do
          it "reports the error to the callback url and re-raises it" do
            job = create(:asyncapi_server_job, {
              class_name: "Runner",
              callback_url: "client_job_url",
              secret: "sekret",
            })

            error = ArgumentError.new("my error")
            error.set_backtrace(["back", "trace"])

            allow(Runner).to receive(:call).
              and_raise(error)
            expect(JobStatusNotifierWorker).to receive(:perform_async).with(job.id, ["my error", "back", "trace"].join("\n"))

            expect { described_class.new.perform(job.id) }.
              to raise_error(error)
            job.reload
            expect(job.status).to eq "error"
          end
        end

        context "job is nil" do
          it "retries JobWorker" do
            expect(JobWorker).to receive(:perform_async).with("999", 1).and_return true
            expect { described_class.new.perform("999") }.to raise_error
          end
        end
      end
    end
  end
end
