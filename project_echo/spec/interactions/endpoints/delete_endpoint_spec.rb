require 'rails_helper'

RSpec.describe Endpoints::DeleteEndpoint do
  describe '#execute' do
    describe 'successful scenarios' do
      it 'updates endpoint' do
        endpoint = create(:endpoint)

        expect do
          described_class.run!(endpoint: endpoint)
        end.to change { Endpoint.all.count }
      end
    end
  end
end
