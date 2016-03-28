require 'rails_helper'

RSpec.describe AppleStore::Gateway do
  let!(:params) do
    {
      endpoint:
        'https://itunes.apple.com/WebObjects/MZStore.woa/wa/'\
        'viewTop?genreId=6001&popId=30&dataOnly=true&l=en',
      headers:
        {
          'Accept-Encoding' => 'gzip, deflate, sdch',
          'Accept-Language' => 'en-US,en;q=0.8,lv;q=0.6',
          'User-Agent' =>
            'iTunes/11.1.1 (Windows; Microsoft Windows 7 x64 Ultimate Edition'\
            ' Service Pack 1 (Build 7601)) AppleWebKit/536.30.1',
          'Accept' =>
            'text/html,application/xhtml+xml'\
            ',application/xml;q=0.9,image/webp,*/*;q=0.8',
          'Cache-Control' => 'max-age=0',
          'X-Apple-Store-Front' => '143441-1,17'
        },
      options: { gz_read: true }
    }
  end

  describe '#perform_api_call' do
    it 'returns a string' do
      response = VCR.use_cassette('apps') do
        subject.perform_api_call(params)
      end
      expect(response).to be_kind_of(String)
    end

    it 'returns content from apple store service' do
      response = VCR.use_cassette('apps') do
        subject.perform_api_call(params)
      end
      expect(response).to match(/adamIds/)
    end
  end
end
