class Endpoints::DeleteEndpoint < BaseInteraction
  object :endpoint, class: 'Endpoint'

  def execute
    ActiveRecord::Base.transaction do
      endpoint.destroy!
    end
  rescue ActiveRecord::RecordInvalid => invalid
    merge_errors(invalid.record)
  rescue ActiveInteraction::InvalidInteractionError => e
    errors.messages[:endpoint] = [e.message]
  end
end
