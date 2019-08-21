# frozen_string_literal: true

# Web archive collection
class Collection < ApplicationRecord
  self.primary_key = 'druid'
  validates_presence_of :title, :druid, :active, :embargo_months, :fetch_start_month, :wasapi_provider_account
  validates :druid, format: { with: /druid:.+/,
                              message: 'must begin with druid:' }

  def wasapi_provider_account
    wasapi_provider && wasapi_account ? "#{wasapi_provider}:#{wasapi_account}" : nil
  end

  def wasapi_provider_account=(provider_account)
    self.wasapi_provider, self.wasapi_account = provider_account.split(':')
  end
end
