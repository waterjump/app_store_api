class AppleStore::Report
  include AppleStore::Concerns::Gateway

  def initialize(params)
    @params = params.with_indifferent_access
  end

  def perform
    device_rankings = {}

    device_codes.each do |device, code|
      data = gateway.perform_api_call(@params.merge!('device' => code))
      device_rankings.merge!(
        device => AppleStore::DeviceRanking.new(data, @params[:monetization])
      )
    end

    #combine ranks
    aggregate_ranking = {}
    device_rankings.each do |device, ranking|
      ranking.ranking.each do |adam_id, rank|
        if aggregate_ranking[adam_id].present?
          aggregate_ranking[adam_id] << rank
        else
          aggregate_ranking[adam_id] = [rank]
        end
      end
    end

    averaged_ranks = {}
    aggregate_ranking.each do |adam_id, ranks|
      averaged_ranks.merge!(
        adam_id => (ranks.reduce(:+).to_f / ranks.size)
      )
    end

    averaged_ranks.sort_by { |adam_id, rank| rank }
  end

  private

  def device_codes
    { iphone: 30, ipad: 47 }
  end
end
