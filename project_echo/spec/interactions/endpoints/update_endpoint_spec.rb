require 'rails_helper'

RSpec.describe Endpoints::UpdateEndpoint do
  describe '#execute' do
    describe 'successful scenarios' do
      it 'updates endpoint' do
        endpoint = create(:endpoint)
        params = {
          verb: 'GET',
          path: '/bar',
          response: {
            code: 200,
            headers: {},
            body: "{\"message\":\"Hello world\"}"
          }
        }

        endpoint = described_class.run!(params.merge(endpoint: endpoint))
        expect(endpoint.reload.path).to eq(params[:path])
      end
    end

    describe 'failure scenarios' do
      context 'when record invalid' do
        it "doesn't update endpoint" do
          endpoint = create(:endpoint)
          params = {
            verb: 'FOO',
            path: '/foo',
            response: {
              code: 200,
              headers: {},
              body: "{\"message\":\"Hello world\"}"
            }
          }

          described_class.run(params.merge(endpoint: endpoint))
          expect(endpoint.reload.verb).not_to eq(params[:verb])
        end
      end
    end
  end
end
