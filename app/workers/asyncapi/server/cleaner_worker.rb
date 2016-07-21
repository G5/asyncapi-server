module Asyncapi
  module Server
    class CleanerWorker

      include Sidekiq::Worker
      sidekiq_options retry: false

      def perform
        Job.expired.find_each(&:destroy)
      end

    end
  end
end

if Sidekiq.server?
  Sidekiq::Cron::Job.create({
    name: "Delete expired jobs",
    cron: Asyncapi::Server.clean_job_cron,
    klass: Asyncapi::Server::CleanerWorker.name,
  })
end
