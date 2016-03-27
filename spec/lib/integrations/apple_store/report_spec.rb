require 'rails_helper'

RSpec.describe AppleStore::Report do
  let(:report) do
    AppleStore::Report.new(
      'category_id' => 6001,
      'monetization' => 'Free')
  end

  subject { report }

  describe '#perform' do
    it 'returns JSON' do
      VCR.use_cassette('apps') do
        expect(subject.perform).to be_kind_of(String)
      end
    end
  end
end
