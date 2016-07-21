require "spec_helper"

module Asyncapi::Server
  describe JobSerializer do

    let(:expired_at) { 2.days.from_now }
    let(:job) { build_stubbed(:asyncapi_server_job, expired_at: expired_at) }
    let(:serializer) { described_class.new(job) }
    subject(:serialized_hash) { serializer.attributes }

    its([:id]) { is_expected.to eq job.id }
    its([:expired_at]) { is_expected.to eq expired_at }

    it "has a url" do
      allow(job).to receive(:url).and_return("url")
      expect(serialized_hash[:url]).to eq "url"
    end

  end
end
