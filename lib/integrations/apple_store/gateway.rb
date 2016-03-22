class AppleStore::Gateway
  cattr_accessor :top_apps_url
  self.top_apps_url =
    'https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?l=en&dataOnly=true'

  def perform_api_call(params = {})
    uri = URI.parse(top_apps_endpoint(params))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri)
    set_top_apps_headers(request)

    response = http.request(request)
    gz = Zlib::GzipReader.new(StringIO.new(response.body.to_s))
    gz.read
  end

  private

  def top_apps_endpoint(params)
    category = "genreId=#{params['category_id']}"
    device = "popId=#{params['device']}"

    [top_apps_url, category, device].join('&')
  end

  def set_top_apps_headers(request)
    request['Accept-Encoding'] = 'gzip, deflate, sdch',
    request['Accept-Language'] = 'en-US,en;q=0.8,lv;q=0.6'
    request['User-Agent'] =
      ['iTunes/11.1.1 (Windows; Microsoft Windows 7 x64 Ultimate Edition',
       'Service Pack 1 (Build 7601)) AppleWebKit/536.30.1'].join(' ')
    request['Accept'] =
      ['text/html,application/xhtml+xml',
       'application/xml;q=0.9,image/webp,*/*;q=0.8'].join(',')
    request['Cache-Control'] = 'max-age=0'
    request['X-Apple-Store-Front'] = '143441-1,17'
    request
  end
end
