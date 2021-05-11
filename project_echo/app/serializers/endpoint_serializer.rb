class EndpointSerializer < ActiveModel::Serializer
  type 'endpoints'

  attributes :id, :verb, :path, :response
end
