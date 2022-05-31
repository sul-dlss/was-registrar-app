# frozen_string_literal: true

# Supports retrying fetches for FetchMonths.
# Retrying is performed for FetchMonths that are after the last FetchMonth that resulted in
# registration of an item and have a stateus of success or failure.
class FetchJobRetrier
  # @return [boolean] true if there are fetch months that can be retried.
  def self.retry?(collection:)
    new(collection.id).retry?
  end

  # Requeues FetchMonths that can be retried.
  def self.retry(collection:)
    new(collection.id).retry
  end

  def initialize(collection_id)
    @collection_id = collection_id
  end

  def retry?
    retriable_fetch_months.exists?
  end

  def retry
    retriable_fetch_months.each do |fetch_month|
      fetch_month.update(status: 'waiting', failure_reason: nil)
      FetchJob.perform_later(fetch_month)
    end
  end

  private

  attr_reader :collection_id

  def last_registered_fetch_month
    @last_registered_fetch_month ||= FetchMonth
                                     .where(collection_id: collection_id)
                                     .where(status: 'success')
                                     .where.not(crawl_item_druid: nil).order(id: :desc)
                                     .limit(1)
                                     .first
  end

  def retriable_fetch_months
    @retriable_fetch_months ||= begin
      fetch_months = FetchMonth.where(collection_id: collection_id, status: %w[success failure])
      last_registered_fetch_month ? fetch_months.where('id > ?', last_registered_fetch_month.id) : fetch_months
    end
  end
end
