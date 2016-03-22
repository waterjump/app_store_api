require 'rails_helper'

RSpec.describe AppleStore::Gateway do
  let!(:endpoint) do
   'https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?genreId=6001&popId=30&dataOnly=true&l=en'
  end
  let!(:headers) do
    {
      'Accept-Encoding' => 'gzip, deflate, sdch',
      'Accept-Language' => 'en-US,en;q=0.8,lv;q=0.6',
      'User-Agent' =>
        ['iTunes/11.1.1 (Windows; Microsoft Windows 7 x64 Ultimate Edition',
         'Service Pack 1 (Build 7601)) AppleWebKit/536.30.1'].join(' '),
      'Accept' =>
        ['text/html,application/xhtml+xml',
         'application/xml;q=0.9,image/webp,*/*;q=0.8'].join(','),
      'Cache-Control' => 'max-age=0',
      'X-Apple-Store-Front' => '143441-1,17'
    }
  end
  let!(:options) do
    { gz_read: true }
  end

  describe '#perform_api_call' do
    it 'returns a string' do
      response = subject.perform_api_call(endpoint, headers, options)
      expect(response).to be_kind_of(String)
    end

    it 'returns content from apple store service' do
      response = subject.perform_api_call(endpoint, headers, options)
      expect(response).to match(/adamIds/)
    end
  end
end
