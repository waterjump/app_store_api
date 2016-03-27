class AppleStore::Report
  include AppleStore::Concerns::Gateway

  cattr_accessor :top_apps_url
  self.top_apps_url =
    'https://itunes.apple.com/WebObjects/MZStore.woa/wa/viewTop?l=en&dataOnly=true'

  def initialize(params)
    @params = params.with_indifferent_access
    @rankings = []
    @results = []
    @max_length = params[:max_length] || 200
  end

  def perform
    fetch_rankings
    combined_ranking = combine_ranking
    averaged_rankings = averaged_rankings(combined_ranking)
    build_results(averaged_rankings)
  end

  private

  def fetch_rankings
    device_codes.each do |code|
      data = Rails.cache.fetch(cache_key('device' => code), expires_in: 24.hours) do
               api_call_params = api_call_params(device: code)
               gateway.perform_api_call(api_call_params)
             end
      device_ranking = AppleStore::DeviceRanking.new(data, @params[:monetization])
      @rankings << device_ranking.ranking
    end
  end

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
    [
      30, #iPhone
      47  #iPad
    ]
  end

  def cache_key(options = {})
    "top-apps-#{cache_params.merge(options).compact.sort.flatten.join('_')}"
  end

  def cache_params
    @params.slice(:category_id, :monetization)
  end

  def combine_ranking
    combined_ranking = {}
    @rankings.each do |ranking|
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

  def averaged_rankings(combined_ranking)
    averaged_rankings = {}
    combined_ranking.each do |adam_id, ranks|
      averaged_rankings.merge!(
        adam_id => (ranks.reduce(:+).to_f / ranks.size)
      )
    end

    averaged_rankings = averaged_rankings.sort_by { |adam_id, rank| rank }

    if @params[:rank].present?
      averaged_rankings = [ averaged_rankings[(@params[:rank].to_i - 1)] ]
    end

    averaged_rankings.to_h
  end

  def build_results(averaged_rankings)
    averaged_rankings.each_with_index do |adam_id, index|
      data = AppleStore::RankedApp.new(adam_id.first).metadata
      @results << data if data.present?
      break if @results.count == @max_length
    end

    @results.to_json
  end
end
