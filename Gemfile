# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 7.0.1'
# Use postgresql as the database for Active Record
gem 'pg'

gem 'sprockets-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'cssbundling-rails'
# Transpile app-like JavaScript.
gem 'jsbundling-rails'

gem 'view_component', '~> 2.0'
# For configuration
gem 'config', '~> 2.0'
gem 'dor-services-client', '~> 12.0'
gem 'dor-workflow-client', '~> 4.0'
gem 'honeybadger'
gem 'okcomputer'

gem 'sidekiq', '~> 6.0'
gem 'simple_form'
gem 'whenever', '~> 1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'capybara'
  gem 'factory_bot_rails'
  # Use Puma as the app server
  gem 'puma', '~> 5.3'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails', '~> 4.0'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'simplecov'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.3'
  gem 'web-console', '>= 4.1.0'
end

group :deployment do
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rvm', require: false
  gem 'dlss-capistrano', require: false
end
