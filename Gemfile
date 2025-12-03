# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem 'auto_strip_attributes'
gem 'bootsnap', '>= 1.1.0', require: false # Reduce boot time via caching; required in config/boot.rb
gem 'config'
gem 'cssbundling-rails'
gem 'honeybadger'
gem 'jsbundling-rails' # Transpile app-like JavaScript.
gem 'okcomputer'
gem 'pg'
gem 'propshaft'
gem 'rails', '~> 8.0.0'
gem 'redis', '~> 4.0' # Redis is needed for turbo-streams
gem 'sidekiq', '~> 7.0'
gem 'simple_form'
gem 'stimulus-rails'
gem 'turbo-rails', '~> 1.0'
gem 'view_component'
gem 'wasapi_client'
gem 'whenever', '~> 1.0', require: false

# dlss gems
gem 'dor-services-client'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'capybara'
  gem 'erb_lint', require: false
  gem 'factory_bot_rails'
  gem 'puma' # app server
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'rubocop-capybara'
  gem 'rubocop-factory_bot'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails'
  gem 'selenium-webdriver'
  gem 'simplecov'
  gem 'webmock'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.3'
  gem 'web-console', '>= 4.1.0'
end

group :deployment do
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'dlss-capistrano', require: false
end
