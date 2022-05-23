# frozen_string_literal: true

set :application, 'was_registrar_app'
set :repo_url, 'https://github.com/sul-dlss/was-registrar-app.git'

# Default branch is :main
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, "/opt/app/was/#{fetch(:application)}"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w[config/database.yml config/honeybadger.yml config/secrets.yml]

# Default value for linked_dirs is []
set :linked_dirs, %w[log config/settings vendor/bundle public/system tmp/pids]

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# All deployed environments run in the production Rails env
set :rails_env, 'production'

# Allow dlss-capistrano to manage sidekiq via systemd
set :sidekiq_systemd_use_hooks, true

# honeybadger_env otherwise defaults to rails_env
set :honeybadger_env, fetch(:stage)

# doesn't appear to do so on our new Ubuntu boxes :shrug:
set :rvm_map_bins, fetch(:rvm_map_bins, []).push('honeybadger')

# update shared_configs before restarting app
before 'deploy:restart', 'shared_configs:update'

before 'deploy:assets:precompile', :yarn_install do
  on roles(:web) do
    within release_path do
      execute("cd #{release_path} && yarn install")
    end
  end
end
