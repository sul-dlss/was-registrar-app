# frozen_string_literal: true

# Web archive collection
class Collection < ApplicationRecord
  self.primary_key = 'druid'
  validates_presence_of :title, :druid, :embargo_months, :fetch_start_month
  validates :active, inclusion: { in: [true, false] }
  validates :druid, format: { with: /druid:.+/,
                              message: 'must begin with druid:' }
end
