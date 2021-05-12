require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  let(:headers) { { 'HTTP_TOKEN' => token_generator } }
  let!(:company) { create(:api_company, access_token: headers['HTTP_TOKEN']) }
  let(:invalid_headers) { { 'HTTP_TOKEN' => nil } }

  describe '#authorize_request' do
    context 'when auth token is passed' do
      before { allow(request).to receive(:headers).and_return(headers) }

      it 'sets the company' do
        expect(subject.instance_eval { authorize_request }).to eq(company)
      end
    end

    context 'when auth token is not passed' do
      before do
        allow(request).to receive(:headers).and_return(invalid_headers)
      end

      it 'raises MissingToken error' do
        expect { subject.instance_eval { authorize_request } }
          .to raise_error(ExceptionHandler::MissingToken, /#{Message.missing_token}/)
      end
    end
  end
end
