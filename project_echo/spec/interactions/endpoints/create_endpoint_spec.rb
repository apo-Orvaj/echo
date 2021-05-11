require 'rails_helper'

RSpec.describe Endpoints::CreateEndpoint do
  describe '#execute' do
    describe 'successful scenarios' do
      it 'creates endpoint' do
        params = {
          verb: 'GET',
          path: '/foo',
          response: {
            code: 200,
            headers: {},
            body: "{\"message\":\"Hello world\"}"
          }
        }

        endpoint = described_class.run!(params)
        expect(endpoint).to be_a Endpoint
      end
    end

    describe 'failure scenarios' do
      context 'when record invalid' do
        it "doesn't create endpoint" do
          params = {
            verb: 'FOO',
            path: '/foo',
            response: {
              code: 200,
              headers: {},
              body: "{\"message\":\"Hello world\"}"
            }
          }

          expect do
            described_class.run(params)
          end.not_to change {
            Endpoint.count
          }
        end
      end
    end
  end
end
