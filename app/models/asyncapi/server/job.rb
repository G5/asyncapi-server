module Asyncapi
  module Server
    class Job < ActiveRecord::Base

      self.table_name = "asyncapi_server_jobs"
      enum status: %i[queued success error]

      def params=(params)
        params = JSON.parse(params) unless params.is_a? Hash
        write_attribute :params, params
      end

      def url
        Engine.routes.url_helpers.v1_job_url(self)
      end

    end
  end
end
