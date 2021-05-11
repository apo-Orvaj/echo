require 'swagger_helper'
require 'json_web_token'

RSpec.describe 'endpoints', type: :request do
  authentication = JsonWebToken.encode
  path '/endpoints' do
    get('list endpoints') do
      tags 'Endpoints'
      parameter({
        :in => :header,
        :type => :string,
        :name => 'Authentication',
        :require => true
      })
      produces 'application/json'
      response '200', 'Lists Endpoints' do
        examples 'application/json' => {
          data: [
            {
              "id": "e33860a4-05c4-420c-b6f0-3a7337e8999f",
              "type": "endpoints",
              "attributes": {
                  "verb": "GET",
                  "path": "/foo",
                  "response": {
                      "code": 200,
                      "headers": {},
                      "body": "{\"message\":\"Hello world\"}"
                  }
              }
            }
          ]
        }
        let('Authentication') { authentication }
        run_test!
      end
    end

    post('creates endpoint') do
      tags 'Endpoints'
      consumes 'application/json'
      parameter({
        :in => :header,
        :type => :string,
        :name => 'Authentication',
        :require => true
      })
      parameter name: :data, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              type: { type: :string },
              attributes: {
                type: :object,
                properties: {
                  verb: { type: :string },
                  path: { type: :string },
                  response: {
                    type: :object,
                    properties: {
                      code: { type: :integer },
                      headers: { type: :object },
                      body: { type: :object }
                    }
                  }
                }
              }
            }
          }
        },
        required: ['verb', 'path', 'response']
      }
      produces 'application/json'
      response '201', 'endpoint created' do
        examples 'application/json' => {
          "data": {
            "id": "e33860a4-05c4-420c-b6f0-3a7337e8999f",
            "type": "endpoints",
            "attributes": {
              "verb": "GET",
              "path": "/foo",
              "response": {
                "code": 200,
                "headers": {},
                "body": "{\"message\":\"Hello world\"}"
              }
            }
          }
        }

        let('Authentication') { authentication }
        let(:data) { {"data": {"type": "endpoints", "attributes": {"verb": "GET", "path": "/foo", "response": {"code": 200, "headers": {}, "body": "{\"message\":\"Hello world\"}"}}}} }
        run_test!
      end
    end
  end

  path '/endpoints/{id}' do
    put('updates endpoint') do
      tags 'Endpoints'
      consumes 'application/json'
      parameter name: 'id', in: :path, type: :string
      parameter({
        :in => :header,
        :type => :string,
        :name => 'Authentication',
        :require => true
      })
      parameter name: :data, in: :body, schema: {
        type: :object,
        properties: {
          data: {
            type: :object,
            properties: {
              id: { type: :string },
              type: { type: :string },
              attributes: {
                type: :object,
                properties: {
                  verb: { type: :string },
                  path: { type: :string },
                  response: {
                    type: :object,
                    properties: {
                      code: { type: :integer },
                      headers: { type: :object },
                      body: { type: :object }
                    }
                  }
                }
              }
            }
          }
        },
        required: ['verb', 'path', 'response']
      }
      produces 'application/json'
      response '200', 'endpoint updated' do
        examples 'application/json' => {
          "data": {
            "id": "e33860a4-05c4-420c-b6f0-3a7337e8999f",
            "type": "endpoints",
            "attributes": {
              "verb": "GET",
              "path": "/foo",
              "response": {
                "code": 200,
                "headers": {},
                "body": "{\"message\":\"Hello world\"}"
              }
            }
          }
        }

        let('Authentication') { authentication }
        let(:data) { {"data": {"type": "endpoints", "attributes": {"verb": "GET", "path": "/foo", "response": {"code": 200, "headers": {}, "body": "{\"message\":\"Hello world\"}"}}}} }
        endpoint = Endpoint.create(verb: 'GET', path: '/foo', response: { code: 200, headers: {}, body: "{\"message\":\"Hello world\"}" })
        let(:id) { endpoint.id }
        run_test!
      end
    end

    delete('delete endpoint') do
      tags 'Endpoints'
      parameter name: 'id', in: :path, type: :string
      parameter({
        :in => :header,
        :type => :string,
        :name => 'Authentication',
        :require => true
      })

      response(204, 'successful') do
        let('Authentication') { authentication }
        endpoint = Endpoint.create(verb: 'GET', path: '/foo', response: { code: 200, headers: {}, body: "{\"message\":\"Hello world\"}" })
        let(:id) { endpoint.id }
        run_test!
      end
    end
  end

  path '/{path}' do
    get('requests the recently created endpoint') do
      produces 'application/json'
      parameter name: 'path', in: :path, type: :string
      response 200 , 'requests the recently created endpoint' do
        examples 'application/json' => {
          "message": "Hello world"
        }
        endpoint = Endpoint.create(verb: 'GET', path: '/foo', response: { code: 200, headers: {}, body: "{\"message\":\"Hello world\"}" })
        let(:path) { endpoint.path }
        run_test!
      end
    end
  end
end
