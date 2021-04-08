require "spec_helper"

module Asyncapi::Server
  describe JobSerializer do

    let(:job) { build_stubbed(:asyncapi_server_job) }
    let(:serializer) { described_class.new(job) }
    subject(:serialized_hash) { serializer.attributes }

    its([:id]) { is_expected.to eq job.id }
    its([:status]) { is_expected.to eq job.status }

    it "has a url" do
      allow(job).to receive(:url).and_return("url")
      expect(serialized_hash[:url]).to eq "url"
    end

  end
end
