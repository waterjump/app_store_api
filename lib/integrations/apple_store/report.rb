class AppleStore::Report
  include AppleStore::Concerns::Gateway

  def initialize(params)
    @params = params.with_indifferent_access
  end

  def perform
    device_rankings = []

    device_codes.values.each do |code|
      data = gateway.perform_api_call(@params.merge!('device' => code))
      device_ranking = AppleStore::DeviceRanking.new(data, @params[:monetization])
      device_rankings << device_ranking.ranking
    end

    #combine ranks
    combined_ranking = combined_ranking(device_rankings)

    averaged_ranks = {}
    combined_ranking.each do |adam_id, ranks|
      averaged_ranks.merge!(
        adam_id => (ranks.reduce(:+).to_f / ranks.size)
      )
    end

    averaged_ranks.sort_by { |adam_id, rank| rank }
  end

  private

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

  def device_codes
    { iphone: 30, ipad: 47 }
  end
end
