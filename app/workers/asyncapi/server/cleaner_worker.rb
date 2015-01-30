module Asyncapi
  module Server
    class CleanerWorker

      include Sidekiq::Worker
      sidekiq_options retry: false

      def perform
        Job.where(Job.arel_table[:expired_at].lt(Time.now)).find_each do |job|
          job.destroy
        end
      end

    end
  end
end
