class AppleStore::Report
  include AppleStore::Concerns::Gateway

  cattr_accessor :top_apps_url
  self.top_apps_url =
    'https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?l=en&dataOnly=true'

  def initialize(params)
    @params = params.with_indifferent_access
  end

  def perform
    device_rankings = []

    device_codes.values.each do |code|
      data = Rails.cache.fetch("top_apps-#{cache_key('device' => code)}", expires_in: 24.hours) do
               api_call_params = api_call_params(device: code)
               gateway.perform_api_call(api_call_params)
             end
      device_ranking = AppleStore::DeviceRanking.new(data, @params[:monetization])
      device_rankings << device_ranking.ranking
    end

    combined_ranking = combined_ranking(device_rankings)

    averaged_ranks = averaged_ranks(combined_ranking)
  end

  private

  def api_call_params(options ={})
    {
      endpoint: endpoint(options),
      headers: headers,
      options: { gz_read: true }
    }
  end

  def endpoint(params)
    category = "genreId=#{@params[:category_id]}"
    device = "popId=#{params[:device]}"

    [top_apps_url, category, device].join('&')
  end

  def headers
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

  def device_codes
    { iphone: 30, ipad: 47 }
  end

  def cache_key(options = {})
    @params.merge(options).sort.flatten.join('_')
  end

  def combined_ranking(device_rankings)
    combined_ranking = {}
    device_rankings.each do |ranking|
      ranking.each do |adam_id, rank|
        if combined_ranking[adam_id].present?
          combined_ranking[adam_id] << rank
        else
          combined_ranking[adam_id] = [rank]
        end
      end
    end
    combined_ranking
  end

  def averaged_ranks(combined_ranking)
    averaged_ranks = {}
    combined_ranking.each do |adam_id, ranks|
      averaged_ranks.merge!(
        adam_id => (ranks.reduce(:+).to_f / ranks.size)
      )
    end

    averaged_ranks.sort_by { |adam_id, rank| rank }
      .first(200)
      .to_h
  end
end
