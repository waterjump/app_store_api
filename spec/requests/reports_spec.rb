require 'rails_helper'

RSpec.describe Api::ReportsController, type: :controller do
  describe 'GET #show' do
    let!(:good_params) do
      {
        id: '',
        format: :json,
        category_id: 1025,
        monetization: 'paid'
      }
    end

    let!(:bad_params) do
      {
        id: '',
        format: :json
      }
    end

    it 'responds successfully with an HTTP 200 status code' do
      get :show, good_params
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'returns a simple response' do
      get :show, good_params
      results = JSON.parse(response.body)
      expect(results['hello']).to eq 'world'
    end

    it 'requires certain parameters' do
      get :show, bad_params
      expect(response).to have_http_status(400)
    end
  end
end
