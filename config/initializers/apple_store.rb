AppStoreApi::Application.configure do
  config.gateways = {}
  config.gateways[:apple_store] = AppleStore::Gateway.new
end
