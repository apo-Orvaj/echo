require 'swagger_helper'

RSpec.describe 'auth', type: :request do

  path '/authentication_token' do
    post('generates authentication_token') do
      tags 'Authentication'
      produces 'application/json'
      response '200', 'endpoint created' do
        examples 'application/json' => {
          "Authentication": 'eyJhbGciOiJIUzI1NiJ9.eyJBdXRoZW50aWNhdGlvbiI6IjA5ZjVkYWMwLTU2YzAtNDE1Mi04YTZiLWEyZTRlYzY5ODk2MSIsImV4cCI6MTYyMDgzODExOX0'
        }
        run_test!
      end
    end
  end
end
