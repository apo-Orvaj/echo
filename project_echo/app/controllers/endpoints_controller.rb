class EndpointsController < ApiController
  before_action :set_endpoint, only: %i(update destroy)
  before_action :authenticate_request, except: :show

  def index
    @endpoints = Endpoint.all
    render json: @endpoints,
           each_serializer: EndpointSerializer
  end

  def show
    @endpoint = Endpoint.find_by(verb: request.method, path: "/#{params[:path]}")
    if @endpoint.nil?
      record_not_found("Requested page `/#{params[:path]}` does not exist")
    else
      response.headers.merge!(@endpoint.response['headers']) if @endpoint.response['headers'].present?
      render json: JSON.parse(@endpoint.response['body']),
             status: @endpoint.response['code']
    end
  end

  def create
    outcome = Endpoints::CreateEndpoint.run(endpoint_params[:attributes])
    
    if outcome.valid?
      render json: outcome.result,
             status: 201,
             serializer: EndpointSerializer
    else
      render_error(outcome.errors.full_messages)
    end
  end

  def update
    outcome = Endpoints::UpdateEndpoint.run(endpoint_params[:attributes].merge(endpoint: @endpoint))

    if outcome.valid?
      render json: outcome.result,
             serializer: EndpointSerializer
    else
      render_error(outcome.errors.full_messages)
    end
  end

  def destroy
    outcome = Endpoints::DeleteEndpoint.run(endpoint: @endpoint)

    if outcome.valid?
      head :no_content
    else
      render_error(outcome.errors.full_messages)
    end
  end

  private

  def authenticate_request
    header = request.headers['Authentication']
    begin
      JsonWebToken.decode(header)
    rescue JWT::DecodeError
      errors = header.present? ? 'Authentication token incorrect' : 'Authentication token required'
      render json: { errors: errors }, status: :unauthorized
    end
  end

  def set_endpoint
    @endpoint = Endpoint.find_by(id: params[:id])
    record_not_found("Requested Endpoint with ID `#{params[:id]}` does not exist") if @endpoint.nil?
  end

  def endpoint_params
    params.require(:data).permit(:type, attributes: [:verb, :path, response: [:code, :body, headers: {}]])
  end
end