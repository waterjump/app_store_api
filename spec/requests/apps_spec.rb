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

    let!(:invalid_mon_params) do
      {
        format: :json,
        category_id: 6001,
        monetization: 'Aliens'
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

    it 'requires rank to be an integer' do
      get :index, good_params.merge!(rank: 4.20)
      expect(response).to have_http_status(400)
    end

    it 'requires rank to be greater than 0' do
      get :index, good_params.merge!(rank: -69)
      expect(response).to have_http_status(400)
    end

    it 'requires rank to be less than 201' do
      get :index, good_params.merge!(rank: 666)
      expect(response).to have_http_status(400)
    end

    it 'requires monetization to be a certain value' do
      get :index, invalid_mon_params
      expect(response).to have_http_status(400)
    end

    it 'returns a list of top apps' do
      get :index, good_params
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to be_kind_of(Array)
      expect(parsed_body.count).to eq(200)
      expect(parsed_body.first['id'].present?).to be true
      expect(parsed_body.first['name'].present?).to be true
      expect(parsed_body.first['description'].present?).to be true
      expect(parsed_body.first['small_icon_url'].present?).to be true
      expect(parsed_body.first['publisher_name'].present?).to be true
      expect(parsed_body.first['price'].present?).to be true
      expect(parsed_body.first['version'].present?).to be true
      expect(parsed_body.first['average_user_rating'].present?).to be true
    end

    it 'returns a single app by rank' do
      get :index, good_params.merge!(rank: 69)
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to be_kind_of(Hash)
      expect(parsed_body['id'].present?).to be true
      expect(parsed_body['name'].present?).to be true
      expect(parsed_body['description'].present?).to be true
      expect(parsed_body['small_icon_url'].present?).to be true
      expect(parsed_body['publisher_name'].present?).to be true
      expect(parsed_body['price'].present?).to be true
      expect(parsed_body['version'].present?).to be true
      expect(parsed_body['average_user_rating'].present?).to be true
    end
  end
end
