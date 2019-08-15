# frozen_string_literal: true

server 'was-registrar-app-stage.stanford.edu', user: 'was', roles: %w[web app db]

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'production'
set :bundle_without, %w[deployment test development].join(' ')
