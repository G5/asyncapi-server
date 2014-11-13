module Asyncapi
  module Server
    class JobSerializer < ActiveModel::Serializer

      attributes :id, :url

    end
  end
end

