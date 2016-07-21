require "spec_helper"

describe "Enqueueing jobs", type: :request do

  let(:job) do
    build_stubbed(:asyncapi_server_job, secret: "secret", expired_at: expired_at)
  end
  let(:expired_at) { 2.days.from_now }

  before do
    allow(Asyncapi::Server::Job).to receive(:create).with(
      class_name: "Runner",
      callback_url: "callback_url",
      params: {client: "params"}.to_json,
      secret: "secret",
      expired_at: expired_at.to_s,
    ).and_return(job)

    allow(job).to receive(:url).and_return("server_job_url")
  end

  it "allows asynchronous handling of http requests and cleans up old jobs" do
    expect(Asyncapi::Server::JobWorker).to receive(:perform_async).with(job.id)

    post("/tests", job: {
      callback_url: "callback_url",
      params: {client: "params"}.to_json,
      secret: "secret",
      expired_at: expired_at,
    })

    expect(response).to be_successful
    parsed_response = indifferent_hash(response.body)[:job]
    expect(parsed_response[:url]).to eq "server_job_url"
    expect(parsed_response[:secret]).to eq "secret"
    expect(Time.parse(parsed_response[:expired_at]).to_i).to eq expired_at.to_i
  end

end
