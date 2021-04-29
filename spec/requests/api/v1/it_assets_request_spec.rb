require 'rails_helper'

RSpec.describe 'Api::V1::ItAssets', type: :request do
  let(:headers) { valid_headers }
  let!(:company) { create(:api_company, access_token: headers['HTTP_TOKEN']) }

  describe 'GET /api/v1/it_assets/filter' do
    before { get '/api/v1/it_assets/filter', headers: headers }

    it 'returns it_assets' do
      # `json` is a custom helper to parse JSON responses present in request_spec_helper.rb
      expect(json).to be_empty
      expect(json.size).to eq(0)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    context 'when the request is invalid' do
      before { get '/api/v1/it_assets/filter' }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
end
