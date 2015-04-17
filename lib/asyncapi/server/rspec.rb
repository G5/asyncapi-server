module Asyncapi
  module Server
    module RSpec

      def asyncapi_post(url, params)
        post(url, {
          job: {
            callback_url: "callback_url",
            params: params,
            secret: "sekret",
          }
        })
      end

    end
  end
end

RSpec.configuration.include Asyncapi::Server::RSpec, type: :request
