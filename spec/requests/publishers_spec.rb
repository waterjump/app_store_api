require 'rails_helper'

RSpec.describe Api::PublishersController, type: :controller do
  it_behaves_like "a get request"

  describe 'GET #index' do
    let!(:good_params) do
      {
        format: :json,
        category_id: 6012,
        monetization: 'paid'
      }
    end

    it 'responds successfully with an HTTP 200 status code' do
      get :index, good_params
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'returns JSON' do
      get :index, good_params
      parsed_body = JSON.parse(response.body)
      expect(parsed_body.first['publisher_id'].present?).to be true
      expect(parsed_body.first['publisher_name'].present?).to be true
      expect(parsed_body.first['rank'].present?).to be true
      expect(parsed_body.first['number_of_apps'].present?).to be true
      expect(parsed_body.first['app_names'].present?).to be true
      expect(parsed_body.first['app_names']).to be_kind_of(Array)
      first_entry = parsed_body[0]
      later_entry = parsed_body[15]
      expect(first_entry['number_of_apps']).to be > later_entry['number_of_apps']
    end
  end
end
