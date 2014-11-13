require "spec_helper"

describe "Enqueueing jobs", type: :request do

  let(:job) { build_stubbed(:asyncapi_server_job) }

  before do
    allow(Asyncapi::Server::Job).to receive(:create).with(
      class_name: "Runner",
      callback_url: "callback_url",
      params: {client: "params"}.to_json,
    ).and_return(job)

    allow(job).to receive(:url).and_return("server_job_url")
  end

  it "allows asynchronous handing of http requests" do
    expect(Asyncapi::Server::JobWorker).to receive(:perform_async).with(job.id)

    post("tests", job: {
      callback_url: "callback_url",
      params: {client: "params"}.to_json,
    })

    expect(response).to be_successful
    parsed_response = indifferent_hash(response.body)
    # expect(parsed_response[:url]).to eq "server_job_url"
  end

end
