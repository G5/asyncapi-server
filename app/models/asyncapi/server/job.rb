module Asyncapi
  module Server
    class Job < ActiveRecord::Base

      self.table_name = "asyncapi_server_jobs"
      enum status: %i[queued success error]

      def url
        Engine.routes.url_helpers.v1_job_url(self)
      end

    end
  end
end
