# frozen_string_literal: true

# This represents fetching a particular collection for a particular month
class FetchMonth < ApplicationRecord
  belongs_to :collection
  validates :status, inclusion: { in: %w[waiting running success failure] }

  def crawl_directory
    File.join(Settings.crawl_directory, job_directory)
  end

  def job_directory
    File.join("#{collection.wasapi_provider.upcase}_#{wasapi_account_config.accountid}", "#{year}_#{month}")
  end

  def crawl_start_after
    to_date.iso8601
  end

  def to_date
    Date.parse("#{year}-#{month}-01")
  end

  def crawl_start_before
    (to_date + 1.month).iso8601
  end

  def wasapi_provider_config
    Settings.wasapi_providers[collection.wasapi_provider]
  end

  def wasapi_account_config
    wasapi_provider_config.accounts[collection.wasapi_account]
  end
end
