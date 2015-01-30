module Asyncapi
  module Server
    class Job < ActiveRecord::Base

      self.table_name = "asyncapi_server_jobs"
      enum status: %i[queued success error]

      before_create :set_default_expired_at

      def url
        Engine.routes.url_helpers.v1_job_url(self)
      end

      private

      def set_default_expired_at
        if Server.expiry_threshold
          self.expired_at ||= Server.expiry_threshold.from_now
        end
      end

    end
  end
end
