module Asyncapi
  module Server
    class JobSerializer < ActiveModel::Serializer

      attributes :id, :url, :secret, :expired_at

    end
  end
end

