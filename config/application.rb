require File.expand_path('../boot', __FILE__)

require 'rails'

require 'active_model/railtie'
require 'active_job/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module AppStoreApi
  class Application < Rails::Application
    config.eager_load_paths << "#{config.root}/lib"
    config.eager_load_paths << "#{config.root}/lib/integrations"
  end
end
