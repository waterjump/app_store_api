class AppleStore::DeviceRanking

  attr_reader :ranking

  def initialize(hash, monetization)
    @monetization = monetization

    process(hash)
  end

  private

  def process(data)
    json = JSON.parse(data).with_indifferent_access
    list = case @monetization.downcase
      when 'paid'
        json[:topCharts][0][:adamIds]
      when 'free'
        json[:topCharts][1][:adamIds]
      when 'grossing'
        json[:topCharts][2][:adamIds]
    end

    @ranking = {}
    list.each_with_index do |adam_id, index|
      @ranking.merge!( adam_id => (index + 1) )
    end

    @ranking
  end
end
