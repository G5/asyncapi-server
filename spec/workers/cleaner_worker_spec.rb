require 'spec_helper'

module Asyncapi
  module Server
    describe CleanerWorker, "#perform" do

      it "does not retry" do
        expect(described_class.sidekiq_options_hash['retry']).to be false
      end

      it "destroys jobs older past the expiry date" do
        create(:asyncapi_server_job, expired_at: 1.day.ago)
        remaining_job = create(:asyncapi_server_job, expired_at: 2.days.from_now)

        CleanerWorker.new.perform

        expect(Asyncapi::Server::Job.all.pluck(:id)).
          to match_array(remaining_job.id)
      end

      it "does not destroy jobs that have a nil expired_at" do
        original_expiry_threshold = Server.expiry_threshold
        Server.expiry_threshold = nil
        remaining_job = create(:asyncapi_server_job)
        Server.expiry_threshold = original_expiry_threshold

        CleanerWorker.new.perform

        expect(Asyncapi::Server::Job.all).to match_array(remaining_job)
      end

    end
  end
end
