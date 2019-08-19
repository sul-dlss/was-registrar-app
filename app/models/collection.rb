# frozen_string_literal: true

# Web archive collection
class Collection < ApplicationRecord
  self.primary_key = 'druid'
  validates_presence_of :title, :druid, :active, :embargo_months
  validates :druid, format: { with: /druid:.+/,
                              message: 'must begin with druid:' }
end
