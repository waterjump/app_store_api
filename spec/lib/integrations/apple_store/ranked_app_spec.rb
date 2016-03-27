require 'rails_helper'

RSpec.describe AppleStore::RankedApp do
  let!(:subject) { AppleStore::RankedApp.new('295646461') }

  describe '#metadata' do
    it 'returns a hash' do
      response = VCR.use_cassette('apps') do
        subject.metadata
      end
      expect(response).to be_kind_of(Hash)
    end
  end
end
