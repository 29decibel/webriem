Webreim::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # comment out this line:
  # config.action_view.debug_rjs             = true

  # Do not compress assets
  config.assets.compress = true

  # Expands the lines which load the assets
  config.assets.debug = true

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  #config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  #set the mail config info
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  #this settings is a must
  # config.action_mailer.smtp_settings = {
  #   :address => "smtp.163.com",
  #   :enable_starttls_auto => true,
  #   :port => 25,
  #   :authentication =>:login,
  #   :user_name => "baoxiao_skccsystem@163.com",
  #   :password => 'china123!'
  # }
  config.action_mailer.smtp_settings = {
    :address              => "www.vrvmail.com.cn",
    :port                 => 25,
    :domain               => '211.154.169.179',
    :user_name            => 'baoxiao',
    :password             => 'baoxiao',
    :authentication       => 'plain',
    :enable_starttls_auto => false  }

end

