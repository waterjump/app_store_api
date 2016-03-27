RSpec.shared_examples "a get request" do
  describe 'GET #index' do
    let!(:good_params) do
      {
        format: :json,
        category_id: 6001,
        monetization: 'paid'
      }
    end

    let!(:missing_params) do
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

    let!(:invalid_cat_params_2) do
      {
        format: :json,
        category_id: 1987,
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
      VCR.use_cassette('apps') { get :index, good_params }
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it 'requires category_id and monetization parameters' do
      get :index, missing_params
      expect(response).to have_http_status(400)
    end

    it 'requires a numeric category_id' do
      get :index, invalid_cat_params
      expect(response).to have_http_status(400)
    end

    it 'rejects non app store category_ids' do
      get :index, invalid_cat_params_2
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
  end
end
