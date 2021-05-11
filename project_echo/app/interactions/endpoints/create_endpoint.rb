class Endpoints::CreateEndpoint < BaseInteraction
  string :verb
  string :path
  
  hash :response do
    integer :code
    hash :headers, default: {}
    string :body, default: nil
  end

  def execute
    endpoint = Endpoint.new(inputs)
    begin
      ActiveRecord::Base.transaction do
        endpoint.save!
      end
    rescue ActiveRecord::RecordInvalid => invalid
      merge_errors(invalid.record)
    rescue ActiveInteraction::InvalidInteractionError => e
      errors.messages[:endpoint] = [e.message]
    end

    endpoint
  end
end
