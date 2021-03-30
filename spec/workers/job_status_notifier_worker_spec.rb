require "spec_helper"

module Asyncapi
  module Server
    describe JobStatusNotifierWorker do

      it "does not retry" do
        expect(described_class.sidekiq_options_hash['retry']).to be false
      end

      describe "#perform" do
        let(:message) { nil }
        let(:code) { 200 }
        let(:body) do
          {
            id: 12345,
            server_job_url: "server_job_url",
            status: "success",
          }
        end
        let(:response) do
          double(:response_double,
            code: code,
            body: body,
          )
        end
        let(:job) do
          create(:asyncapi_server_job, {
            class_name: "Runner",
            callback_url: "client_job_url",
            status: :success,
            secret: "secret",
          })
        end

        it "notifies a job's callback_url with the job status" do
          expect(Typhoeus).to receive(:put).with(
            job.callback_url,
            body: {
              job: {
                status: job.status,
                message: message,
                secret: job.secret,
              }
            }.to_json,
            headers: {
              "Content-Type" => "application/json",
              Accept: "application/json"
            }
          ).and_return(response)

          described_class.new.perform(job.id, message)
        end

        context "when an error occurred while notifying callback_url" do
          let(:code) { 404 }
          let(:body) do
            {
              error: "404",
              status: "Not Found",
            }
          end
          let(:jid) { "abcde12345" }

          before do
            expect(Typhoeus).to receive(:put).with(
              job.callback_url,
              body: {
                job: {
                  status: job.status,
                  message: message,
                  secret: job.secret,
                }
              }.to_json,
              headers: {
                "Content-Type" => "application/json",
                Accept: "application/json"
              }
            ).and_return(response)
          end

          context "when initial attempt fails" do
            let(:retries) { 1 }
            let(:expected_error_message) do
              [
                "Attempt##{retries} to notify #{job.callback_url} failed.",
                "JobID: #{job.id}",
                "Next Attempt: #{jid}",
                "HTTP Status: #{response.code}",
                "HTTP Response: #{response.inspect}",
              ].join("\n")
            end

            it "raises attempt failure and retries" do
              expect(JobStatusNotifierWorker).to(
                receive(:perform_async).with(job.id, message, retries+1).and_return(jid)
              )

              expect { described_class.new.perform(job.id, message, retries) }.to(
                raise_error expected_error_message
              )
            end
          end

          context "when final attempt still fails" do
            let(:expected_error_message) do
              [
                "Something went wrong while poking #{job.callback_url}",
                "JobID: #{job.id}",
                "Next Attempt: ",
                "HTTP Status: #{response.code}",
                "HTTP Response: #{response.inspect}",
              ].join("\n")
            end

            it "raises error if no progress is made after MAX_RETRIES attempts" do
              expect { described_class.new.perform(job.id, message, 3) }.to(
                raise_error expected_error_message
              )
            end
          end
        end
      end
    end
  end
end
