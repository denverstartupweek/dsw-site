# Set a default host for mailers
Rails.application.routes.default_url_options[:host] = ENV["ACTION_MAILER_HOST"]
