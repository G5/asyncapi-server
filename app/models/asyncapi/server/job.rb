module Asyncapi
  module Server
    class Job < ActiveRecord::Base

      self.table_name = "asyncapi_server_jobs"
      enum status: %i[queued success error]
      scope :expired, -> do
        expired_at = arel_table[:expired_at]
        where.not(expired_at: nil).where(expired_at.lt(Time.now))
      end

      def url
        Engine.routes.url_helpers.v1_job_url(self)
      end

    end
  end
end
