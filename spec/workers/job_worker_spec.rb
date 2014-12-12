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
          expect(Typhoeus).to receive(:put).with(
            "client_job_url",
            body: {
              job: {
                status: :success,
                message: "message",
                secret: "sekret",
              }
            }.to_json,
            headers: {
              "Content-Type" => "application/json",
              Accept: "application/json"
            }
          )

          described_class.new.perform(job.id)
          job.reload
          expect(job.status).to eq "success"
        end

        context "an error occurred" do
          it "reports the error to the callback url" do
            job = create(:asyncapi_server_job, {
              class_name: "Runner",
              callback_url: "client_job_url",
              secret: "sekret",
            })

            error = ArgumentError.new("my error")
            error.set_backtrace(["back", "trace"])

            allow(Runner).to receive(:call).
              and_raise(error)

            expect(Typhoeus).to receive(:put).with(
              "client_job_url",
              body: {
                job: {
                  status: :error,
                  message: ["my error", "back", "trace"].join("\n"),
                  secret: "sekret",
                }
              }.to_json,
              headers: {
                "Content-Type" => "application/json",
                Accept: "application/json"
              }
            )

            described_class.new.perform(job.id)
            job.reload
            expect(job.status).to eq "error"
          end
        end
      end

    end
  end
end
