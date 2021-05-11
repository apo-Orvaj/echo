class AuthController < ApiController
  def create
    render json: { 'Authentication': JsonWebToken.encode }
  end
end
