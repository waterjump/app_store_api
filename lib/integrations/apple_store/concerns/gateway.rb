module AppleStore
  module Concerns
    module Gateway
      def gateway
        AppStoreApi::Application.config.gateways[:apple_store]
      end
    end
  end
end
