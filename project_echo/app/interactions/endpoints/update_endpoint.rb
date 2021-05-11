class Endpoints::UpdateEndpoint < BaseInteraction
  object :endpoint, class: 'Endpoint'

  string :verb
  string :path
  
  hash :response do
    integer :code
    hash :headers, default: {}
    string :body, default: nil
  end

  def execute
    begin
      endpoint.update!(params)
    rescue ActiveRecord::RecordInvalid => invalid
      merge_errors(invalid.record)
    rescue ActiveInteraction::InvalidInteractionError => e
      errors.messages[:endpoint] = [e.message]
    end

    endpoint
  end

  private

  def params
    inputs.except(:endpoint)
  end
end
