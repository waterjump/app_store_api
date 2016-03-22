class AppleStore::Report
  include AppleStore::Concerns::Gateway

  def initialize(params)
    @params = params.with_indifferent_access
  end

  def perform
    #make api call for each device
    iphone_data = gateway.perform_api_call(@params.merge!('device' => 30))
    ipad_data = gateway.perform_api_call(@params.merge!('device' => 47))

    ipad_json = JSON.parse(ipad_data).with_indifferent_access
    iphone_json = JSON.parse(iphone_data).with_indifferent_access

    case @params[:monetization].downcase
      when 'paid'
        iphone_list = iphone_json[:topCharts][0][:adamIds]
        ipad_list = ipad_json[:topCharts][0][:adamIds]
      when 'free'
        iphone_list = iphone_json[:topCharts][1][:adamIds]
        ipad_list = ipad_json[:topCharts][1][:adamIds]
      when 'grossing'
        iphone_list = iphone_json[:topCharts][2][:adamIds]
        ipad_list = ipad_json[:topCharts][2][:adamIds]
    end

    #combine api calls

    #fetch app-specific data

  end
end
