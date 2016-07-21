require 'active_model_serializers'
require 'responders'
require 'ar_after_transaction'
require "asyncapi/server/engine"

module Asyncapi
  module Server

    CONFIGURATION = {
      expiry_threshold: 10.days,
    }

    CONFIGURATION.each do |var, default|
      mattr_accessor var
      self.send(:"#{var}=", default)
    end

  end
end
