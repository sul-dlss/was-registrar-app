# frozen_string_literal: true

server 'was-registrar-app.stanford.edu', user: 'was', roles: %w[web app db]

Capistrano::OneTimeKey.generate_one_time_key!
