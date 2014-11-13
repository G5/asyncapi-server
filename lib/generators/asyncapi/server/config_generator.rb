require "asyncapi/server/engine"

module Asyncapi::Server
  class ConfigGenerator < Rails::Generators::Base

    desc "Inserts routes code for Asyncapi::Server"

    def mount_on_routes
      inject_into_file(
        "config/routes.rb",
        %Q(  mount Asyncapi::Server::Engine, at: "/asyncapi/server"\n),
        before: /^end/
      )
    end

  end
end
