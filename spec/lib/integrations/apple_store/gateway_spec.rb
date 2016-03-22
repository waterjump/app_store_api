require 'rails_helper'

RSpec.describe AppleStore::Gateway do
  let(:params) do
    { 'category_id' => 6001, 'device' => 30 }
  end
  describe '#perform_api_call' do
    it 'returns a string' do
      response = subject.perform_api_call(params)
      expect(response).to be_kind_of(String)
    end

    it 'returns content from apple store service' do
      response = subject.perform_api_call(params)
      expect(response).to match(/adamIds/)
    end
  end
end
