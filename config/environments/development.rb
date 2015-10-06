Mcblooms::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log


  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  ActiveMerchant::Billing::Base.mode = :test
  # CREDIT_CARD_ACCOUNT_INFO = {:merchant_id => '810000004283',:login => 'BASKETCOMPANY83', :password => '9YJ97V2LPN18CWS', :bin => '000002'}
  CREDIT_CARD_ACCOUNT_INFO = {:merchant_id => '700000203521', :login => 'BASKETCO13', :password => 'PA55WORD'}

  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.default_url_options = { :host => "mcblooms.dev" }
end
