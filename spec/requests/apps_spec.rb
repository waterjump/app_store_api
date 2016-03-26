require 'rails_helper'

RSpec.describe Api::AppsController, type: :controller do
  describe 'GET #index' do
    let!(:good_params) do
      {
        format: :json,
        category_id: 6001,
        monetization: 'paid'
      }
    end

    let!(:bad_params) do
      {
        format: :json
      }
    end

    let!(:invalid_cat_params) do
      {
        format: :json,
        category_id: 'QQQ',
        monetization: 'paid'
      }
    end

    it 'responds successfully with an HTTP 200 status code' do
      get :index, good_params
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'requires category_id and monetization parameters' do
      get :index, bad_params
      expect(response).to have_http_status(400)
    end

    it 'requires a numberic category_id' do
      get :index, invalid_cat_params
      expect(response).to have_http_status(400)
    end

    it 'returns json' do
      get :index, good_params
      parsed_body = JSON.parse(response.body)
      expect(parsed_body.first['id'].present?).to be true
      expect(parsed_body.first['name'].present?).to be true
      expect(parsed_body.first['description'].present?).to be true
      expect(parsed_body.first['small_icon_url'].present?).to be true
      expect(parsed_body.first['publisher_name'].present?).to be true
      expect(parsed_body.first['price'].present?).to be true
      expect(parsed_body.first['version'].present?).to be true
      expect(parsed_body.first['average_user_rating'].present?).to be true
    end
  end
end
