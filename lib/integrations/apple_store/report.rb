class AppleStore::Report
  include AppleStore::Concerns::Gateway

  def initialize(params)
    @params = params.with_indifferent_access
  end

  def perform
    device_rankings = []

    device_codes.values.each do |code|
      data = Rails.cache.fetch(cache_key(code), expires_in: 24.hours) do
               gateway.perform_api_call(@params.merge('device' => code))
             end
      device_ranking = AppleStore::DeviceRanking.new(data, @params[:monetization])
      device_rankings << device_ranking.ranking
    end

    combined_ranking = combined_ranking(device_rankings)

    averaged_ranks = averaged_ranks(combined_ranking)
  end

  private

  def device_codes
    { iphone: 30, ipad: 47 }
  end

  def cache_key(device_code)
    @params.merge('device' => device_code).sort.flatten.join('_')
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
