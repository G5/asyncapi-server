require 'spec_helper'

module Asyncapi
  module Server
    RSpec.describe CleanerWorker do

      it "does not retry" do
        expect(described_class.sidekiq_options_hash['retry']).to be false
      end

      describe "#perform" do
        let!(:job_1) do
          create(:asyncapi_server_job, expired_at: 2.minutes.ago)
        end
        let!(:job_2) do
          create(:asyncapi_server_job, expired_at: 2.minutes.from_now)
        end
        let!(:job_3) do
          create(:asyncapi_server_job, expired_at: 2.minutes.ago)
        end
        let!(:job_4) do
          create(:asyncapi_server_job, expired_at: nil)
        end

        it "deletes jobs that are expired" do
          described_class.new.perform
          expect(Job.all).to match_array([job_2, job_4])
        end
      end

    end
  end
end
