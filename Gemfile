source "https://rubygems.org"

# Override this source definition to fetch via SSL
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.5.3"

gem "bootsnap"
gem "mime-types", ">= 2.6.1", require: "mime/types/columnar"
gem "pg"
gem "puma"
gem "puma_worker_killer"
gem "rails", "~> 6.0.3"
gem "rake"

gem "autoprefixer-rails"
gem "font_assets"
gem "sassc-rails"
gem "slim-rails"
gem "uglifier"
gem "webpacker"

gem "addressable"
gem "carrierwave"
gem "carrierwave_backgrounder", github: "hyp3rventures/carrierwave_backgrounder" # Forked version for mime-types dependency upgrade
gem "commonmarker"
gem "devise"
gem "email_inquire"
gem "fog-aws"
gem "gemoji"
gem "gravatarify"
gem "honeypot-captcha", github: "RandieM/honeypot-captcha", branch: "master"
gem "html-pipeline", require: "html/pipeline"
gem "httparty"
gem "icalendar"
gem "jsonb_accessor"
gem "liquid"
gem "mini_magick"
gem "piet"
gem "piet-binary"
gem "premailer-rails"
gem "recaptcha"
gem "responders"
gem "retries"
gem "rinku"
gem "sanitize"
gem "sendgrid", github: "caring/sendgrid"
gem "sendgrid-ruby"
gem "textacular"
gem "truncato"

# State machines
gem "simple_states", github: "svenfuchs/simple_states", branch: "v1.1.0.rc11"

# API
gem "active_model_serializers", "~> 0.8.0"

# Production support
gem "honeybadger"
gem "newrelic_rpm"
gem "rack-canonical-host"
gem "skylight"
gem "utf8-cleaner"

# Admin interface
gem "activeadmin"
gem "activeadmin-ajax_filter"
gem "activeadmin_medium_editor", github: "nyrf/activeadmin_medium_editor", ref: "8c60d49"
gem "google-api-client", "~> 0.34"
gem "omniauth-google-oauth2"
gem "omniauth-zoom"
gem "paper_trail"
gem "validate_url"

# Background processing
gem "sidecloq"
gem "sidekiq"
gem "sidekiq-throttled"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "derailed_benchmarks"
  gem "listen"
  gem "standardrb", require: false
end

group :development, :test do
  gem "dotenv-rails"
  gem "pry-rails"
  gem "rspec-rails"
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "email_spec"
  gem "factory_bot_rails"
  gem "rspec-rails-time-metadata"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "vcr"
  gem "webdrivers", require: "webdrivers/chromedriver"
  gem "webmock", require: false
end

group :production do
  gem "dalli"
  gem "heroku-deflater"
  gem "lograge"
  gem "memcachier"
  gem "rack-timeout"
end
