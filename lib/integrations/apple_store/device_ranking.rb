class AppleStore::DeviceRanking

  def initialize(data, monetization)
    @data = data
    @monetization = monetization
  end

  def ranking
    json = JSON.parse(@data).with_indifferent_access
    begin
      list = case @monetization.downcase
        when 'paid'
          json[:topCharts][0][:adamIds]
        when 'free'
          json[:topCharts][1][:adamIds]
        when 'grossing'
          json[:topCharts][2][:adamIds]
      end
    rescue Exception => e
      Rails.logger.error "DeviceRanking error: #{e.message}"
      []
    end

    return {} unless list.present?

    @ranking = {}
    list.each_with_index do |adam_id, index|
      @ranking.merge!( adam_id => (index + 1) )
    end

    @ranking
  end
end
