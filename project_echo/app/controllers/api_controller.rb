require 'json_web_token'

# Api Controller
class ApiController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def render_error(message, status = :unprocessable_entity)
    render json: {
      errors: [
        {
          status: status,
          message: message
        }
      ]
    }, status: status
  end

  def record_not_found(message, status = :not_found)
    render json: {
      errors: [
        {
          code: status,
          detail: message
        }
      ]
    }, status: status
  end
end
