# frozen_string_literal: true

# Web archive collection
class Collection < ApplicationRecord
  self.primary_key = 'druid'

  has_one  :admin_policy
  has_many :fetch_months
  scope :active, -> { where(active: true) }

  validates_presence_of :title, :druid, :embargo_months, :fetch_start_month, :wasapi_provider_account,
                        :wasapi_collection_id
  validates :active, inclusion: { in: [true, false] }
  validates :druid, format: { with: /druid:.+/,
                              message: 'must begin with druid:' }

  after_initialize  :set_defaults, unless: :persisted?

  def set_defaults
    self.admin_policy ||= AdminPolicy.find_by(druid: 'druid:wr005wn5739')
  end

  def wasapi_provider_account
    wasapi_provider && wasapi_account ? "#{wasapi_provider}:#{wasapi_account}" : nil
  end

  def wasapi_provider_account=(provider_account)
    self.wasapi_provider, self.wasapi_account = provider_account.split(':')
  end
end
