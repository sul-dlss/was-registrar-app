# frozen_string_literal: true

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# Learn more: http://github.com/javan/whenever
require_relative 'environment'

# These define jobs that checkin with Honeybadger.
# If changing the schedule of one of these jobs, also update at https://app.honeybadger.io/projects/63547/check_ins
job_type :rake_hb,
         'cd :path && :environment_variable=:environment bundle exec rake --silent ":task" :output && curl --silent https://api.honeybadger.io/v1/check_in/:check_in'

every 1.day do
  set :check_in, Settings.honeybadger_checkins.fetch_collections
  rake_hb 'fetch_collections'
end
