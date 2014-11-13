require "api-pagination"
require "kaminari"
require "typhoeus"
require "sidekiq"
require "asyncapi/server/rails_ext/controller"
require "active_model/serializer"

module Asyncapi
  module Server
    class Engine < ::Rails::Engine
      isolate_namespace Asyncapi::Server
      engine_name "asyncapi_server"

      config.to_prepare do
        ::ApplicationController.send :include, RailsExt::Controller

        Engine.routes.default_url_options =
          Rails.application.routes.default_url_options
      end

    end
  end
end
