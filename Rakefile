# frozen_string_literal: true

require_relative 'config/application'

Rails.application.load_tasks

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  desc 'Run erblint against ERB files'
  task erblint: :environment do
    puts 'Running erblint...'
    system('bundle exec erblint --lint-all --format compact')
  end

  desc 'Run Yarn linter against JS files'
  task eslint: :environment do
    puts 'Running JS linters...'
    system('yarn run lint')
  end

  desc 'Run all configured linters'
  task lint: %i[rubocop erblint eslint]
rescue LoadError
  # should only be here when gem group development and test aren't installed
end
