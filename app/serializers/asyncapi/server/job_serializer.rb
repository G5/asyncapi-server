module Asyncapi
  module Server
    class JobSerializer < ActiveModel::Serializer

      attributes :id, :url, :secret

    end
  end
end

