module Asyncapi
  module Server
    class CleanerWorker

      def perform
        Job.where(Job.arel_table[:expired_at].lt(Time.now)).find_each do |job|
          job.destroy
        end
      end

    end
  end
end
