require "spec_helper"

describe "Enqueueing jobs", type: :request do

  let(:job) { build_stubbed(:asyncapi_server_job, secret: "secret") }

  it "allows asynchronous handling of http requests and cleans up old jobs", cleaning_strategy: :truncation do
    post("/tests", params: {
      job: {
        callback_url: "callback_url",
        params: {client: "params"}.to_json,
        secret: "secret",
      }
    })

    expect(response).to be_successful
    parsed_response = indifferent_hash(response.body)[:job]
    expect(Asyncapi::Server::JobWorker).
      to have_enqueued_sidekiq_job(parsed_response[:id])
    expect(parsed_response[:url]).to be_present
    expect(parsed_response[:secret]).to eq "secret"
  end

end
