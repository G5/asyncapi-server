module Asyncapi
  module Server
    class JobSerializer < ActiveModel::Serializer

      attributes :id, :status, :url, :secret

    end
  end
end

