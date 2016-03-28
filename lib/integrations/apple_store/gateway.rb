module AppleStore
  class Gateway
    def perform_api_call(params = {})
      uri = URI.parse(params[:endpoint])
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri)
      request = add_headers(request, params[:headers])

      response = http.request(request)

      if params[:options].present? && params[:options][:gz_read]
        gz = Zlib::GzipReader.new(StringIO.new(response.body.to_s))
        gz.read
      else
        response.body
      end
    end

    private

    def add_headers(request, headers)
      return request unless headers.present?
      headers.each do |key, value|
        request[key] = value
      end
      request
    end
  end
end
