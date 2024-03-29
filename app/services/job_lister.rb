# frozen_string_literal: true

require 'sidekiq/api'

# Lists the ActiveRecord objects for the currently running jobs.
class JobLister
  def self.list
    new.list
  end

  def list
    GlobalID::Locator.locate_many(gids)
  rescue Redis::CannotConnectError
    Rails.logger.warn('Cannot connect to Redis to get current jobs. Redis may not be running in dev and testing.')
    []
  end

  private

  def workers
    @workers ||= Sidekiq::Workers.new
  end

  def gids
    payloads.map do |payload|
      Rails.logger.info(payload)
      JSON.parse(payload)['args'][0]['arguments'][0]['_aj_globalid']
    end
  end

  def payloads
    workers.map do |_, _, work|
      work['payload']
    end.compact
  end
end
