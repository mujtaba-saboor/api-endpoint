require 'rails_helper'

RSpec.describe AuthorizeApiRequest do
  let(:header) { { 'HTTP_TOKEN' => token_generator } }
  let(:company) { create(:api_company, access_token: header['HTTP_TOKEN']) }
  subject(:invalid_request_obj) { described_class.new({}) }
  subject(:request_obj) { described_class.new(header) }

  describe '#call' do
    context 'when valid request' do
      it 'returns company object' do
        expect(company.persisted?).to eq(true)
        result = request_obj.call
        expect(result[:company]).to eq(company)
      end
    end

    context 'when invalid request' do
      context 'when missing token' do
        it 'raises a MissingToken error' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::MissingToken, Message.missing_token)
        end
      end

      context 'when invalid token' do
        subject(:invalid_request_obj) do
          described_class.new('HTTP_TOKEN' => token_generator)
        end

        it 'raises an InvalidToken error' do
          expect { invalid_request_obj.call }
            .to raise_error(ExceptionHandler::InvalidToken, /#{Message.invalid_token}/)
        end
      end
    end
  end
end