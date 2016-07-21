require 'active_model_serializers'
require 'responders'
require "asyncapi/server/engine"

module Asyncapi
  module Server

    CONFIGURATION = {
      expiry_threshold: 10.days,
      clean_job_cron: "0 * * * *",
    }

    CONFIGURATION.each do |var, default|
      mattr_accessor var
      self.send(:"#{var}=", default)
    end

  end
end
