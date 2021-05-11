require 'rails_helper'

RSpec.describe AuthController, type: :request do
  describe '#create' do
    it 'throws error' do
      post '/authentication_token', params: {}
      expect(JSON.parse(response.body).keys.first).to eq('Authentication')
    end
  end
end
