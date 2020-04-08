# frozen_string_literal: true

require 'okcomputer'

# /status for 'upness', e.g. for load balancer
# /status/all to show all dependencies
# /status/<name-of-check> for a specific check (e.g. for nagios warning)
OkComputer.mount_at = 'status'
OkComputer.check_in_parallel = true

# REQUIRED checks, required to pass for /status/all
#  individual checks also avail at /status/<name-of-check>

OkComputer::Registry.register 'ruby_version', OkComputer::RubyVersionCheck.new
OkComputer::Registry.register 'crawl_directory', OkComputer::DirectoryCheck.new(Settings.crawl_directory)
OkComputer::Registry.register 'redis', OkComputer::RedisCheck.new(url: 'redis://localhost:6379/1')
OkComputer::Registry.register 'background_jobs', OkComputer::SidekiqLatencyCheck.new('default', 25)
