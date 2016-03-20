require 'rails_helper'

RSpec.describe Api::ReportsController, type: :controller do
  describe 'GET #show' do
    it "responds successfully with an HTTP 200 status code" do
      get :show, id: '', format: :json
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'returns a simple response' do
      get :show, id: '', format: :json
      results = JSON.parse(response.body)
      expect(results['hello']).to eq 'world'
    end
  end
end

