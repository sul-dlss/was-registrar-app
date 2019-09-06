# frozen_string_literal: true

# Web archive collection
class Collection < ApplicationRecord
  has_many :fetch_months
  scope :active, -> { where(active: true) }

  validates_presence_of :title, :druid, :embargo_months, :fetch_start_month, :wasapi_provider_account,
                        :wasapi_collection_id
  validates :active, inclusion: { in: [true, false] }
  validates :admin_policy, inclusion: { in: %w[druid:wr005wn5739 druid:yf700yh0557] }
  validates :druid, format: { with: /druid:.+/,
                              message: 'must begin with druid:' }
  validates_uniqueness_of :wasapi_collection_id,
                          scope: %i[wasapi_provider wasapi_account],
                          message: 'already have a collection configured for this WASAPI collection'

  def wasapi_provider_account
    wasapi_provider && wasapi_account ? "#{wasapi_provider}:#{wasapi_account}" : nil
  end

  def wasapi_provider_account=(provider_account)
    self.wasapi_provider, self.wasapi_account = provider_account.split(':')
  end
end
