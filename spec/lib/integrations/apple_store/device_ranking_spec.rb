require 'rails_helper'

RSpec.describe AppleStore::DeviceRanking do
  describe '#ranking' do

    ranking_data = File.read("#{Rails.root}/spec/fixtures/apple_store/ranking.json")

    let!(:device_ranking) do
      AppleStore::DeviceRanking.new(ranking_data, 'Free')
    end

    it 'returns a hash' do
      response = device_ranking.ranking
      expect(response).to be_kind_of(Hash)
    end
  end
end
