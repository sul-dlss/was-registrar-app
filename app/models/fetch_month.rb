# frozen_string_literal: true

# This represents fetching a particular collection for a particular month
class FetchMonth < ApplicationRecord
  belongs_to :collection
  validates :status, inclusion: { in: %w[waiting running success failure] }

  def crawl_directory
    File.join(Settings.crawl_directory, job_directory)
  end

  def job_directory
    date_part = "#{year}_#{month.to_s.rjust(2, '0')}"
    File.join("#{collection.wasapi_provider.upcase}_#{collection.wasapi_collection_id}", date_part)
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

  def source_id
    # sul:[wasapi provider]-[collectionId]-[YYYY]_[MM]
    date_part = "#{year}_#{month.to_s.rjust(2, '0')}"
    "sul:#{collection.wasapi_provider}-#{collection.wasapi_collection_id}-#{date_part}"
  end
end
