# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.
# rubocop:disable Lint/SuppressedException
begin
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new
rescue LoadError
  # should only be here when gem group development and test aren't installed
end
# rubocop:enable Lint/SuppressedException

require_relative 'config/application'

Rails.application.load_tasks
