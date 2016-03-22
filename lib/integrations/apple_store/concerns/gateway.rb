module AppleStore
  module Concerns
    module Gateway
      def gateway
        Rails.application.config.gateways[:apple_store]
      end
    end
  end
end
