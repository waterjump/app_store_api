require 'rails_helper'

RSpec.describe Api::AppsController, type: :controller do
  it_behaves_like 'a get request'
  describe 'GET #index' do
    let!(:good_params) do
      {
        format: :json,
        category_id: 36,
        monetization: 'free'
      }
    end

    it 'returns a list of top apps' do
      VCR.use_cassette('apps') do
        get :index, good_params
      end
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
      VCR.use_cassette('apps') do
        get :index, good_params.merge!(rank: 69)
      end
      parsed_body = JSON.parse(response.body)
      expect(parsed_body).to be_kind_of(Array)
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
