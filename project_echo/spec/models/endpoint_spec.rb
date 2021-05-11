require 'rails_helper'

RSpec.describe Endpoint, type: :model do
  describe 'validations' do
    subject { create(:endpoint) }
    it { should validate_presence_of(:verb) }
    it { should validate_presence_of(:path) }
    it { should validate_presence_of(:response) }
    it { should validate_inclusion_of(:verb).in_array(%w(GET POST PATCH DELETE)) }

    describe 'validates path' do
      context 'when invalid path' do
        it 'gives error response' do
          endpoint = build(:endpoint, path: '>')
          aggregate_failures do
            expect(endpoint.valid?).to be_falsey
            expect(endpoint.errors.messages[:path].first).to eq 'invalid path'
          end
        end
      end
      
      context 'when valid path' do
        it 'gives success response' do
          endpoint = build(:endpoint, path: '/bar')
          aggregate_failures do
            expect(endpoint.valid?).to be_truthy
            expect(endpoint.errors.messages[:path]).to eq []
          end
        end
      end
    end
  end
end