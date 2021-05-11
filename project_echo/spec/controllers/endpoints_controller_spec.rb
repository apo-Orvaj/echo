require 'rails_helper'

RSpec.describe EndpointsController, type: :request do
  describe '#index' do
    context 'without authentication token' do
      it 'throws error' do
        get '/endpoints'

        expect(JSON.parse(response.body)['errors']).to eq('Authentication token required')
      end
    end

    context 'with authentication token' do
      it 'lists endpoints' do
        endpoint = create(:endpoint)
        headers = { 'Authentication': JsonWebToken.encode }

        get '/endpoints', headers: headers
        expect(JSON.parse(response.body)['data'][0]['type']).to eq('endpoints')
      end
    end
  end

  describe '#show' do
    it 'requests the recently created endpoint' do
      endpoint = create(:endpoint, verb: 'GET', path: '/foo')
      get '/foo'

      aggregate_failures do
        expect(response.body).to eq(endpoint.response['body'])
        expect(response.code.to_i).to eq(endpoint.response['code'])
      end
    end
  end

  describe '#create' do
    context 'without authentication token' do
      it 'throws error' do
        post '/endpoints', params: {}
        expect(JSON.parse(response.body)['errors']).to eq('Authentication token required')
      end
    end

    context 'with authentication token' do
      it 'creates endpoint' do
        params = {"data"=>{"type"=>"endpoints", "attributes"=>{"verb"=>"GET", "path"=>"/foo", "response"=>{"code"=>200, "headers"=>{}, "body"=>"{\"message\":\"Hello world\"}"}}}}
        headers = { 'Authentication': JsonWebToken.encode }

        expect do
          post '/endpoints', params: params, headers: headers
        end.to change { Endpoint.all.count }.by(1)
      end
    end
  end

  describe '#update' do
    context 'without authentication token' do
      it 'throws error' do
        endpoint = create(:endpoint)
        patch "/endpoints/#{endpoint.id}", params: {}
        expect(JSON.parse(response.body)['errors']).to eq('Authentication token required')
      end
    end

    context 'with authentication token' do
      it 'updates endpoint' do
        endpoint = create(:endpoint)
        params = {"data"=>{"type"=>"endpoints", "id"=>endpoint.id, "attributes"=>{"verb"=>"DELETE", "path"=>"/foo", "response"=>{"code"=>200, "headers"=>{'auth': '123'}, "body"=>"{\"message\":\"Hello world\"}"}}}}
        headers = { 'Authentication': JsonWebToken.encode }

        patch "/endpoints/#{endpoint.id}", params: params, headers: headers
        expect(endpoint.reload.verb).to eq('DELETE')
      end
    end
  end

  describe '#delete' do
    context 'without authentication token' do
      it 'throws error' do
        endpoint = create(:endpoint)
        delete "/endpoints/#{endpoint.id}", params: {}
        expect(JSON.parse(response.body)['errors']).to eq('Authentication token required')
      end
    end

    context 'with authentication token' do
      it 'updates endpoint' do
        endpoint = create(:endpoint)
        headers = { 'Authentication': JsonWebToken.encode }

        expect do
          delete "/endpoints/#{endpoint.id}", headers: headers
        end.to change { Endpoint.all.count }.by(-1)
      end
    end
  end
end
