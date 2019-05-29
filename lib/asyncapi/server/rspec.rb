module Asyncapi
  module Server
    module RSpec

      def asyncapi_post(url, params)
        formatted_params = format_params(params)
        post(url, formatted_params)
      end

      private

      def format_params(params)
        if params.is_a?(Hash) && params.has_key?(:params)
          params = params[:params]
          return { params: base_params(params) }
        else
          return base_params(params)
        end
      end

      def base_params(params)
        return { job: {
          callback_url: "callback_url",
          params: params,
          secret: "sekret",
        }}
      end
    end
  end
end

RSpec.configuration.include Asyncapi::Server::RSpec, type: :request
