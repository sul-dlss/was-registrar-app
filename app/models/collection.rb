# frozen_string_literal: true

class Collection < ApplicationRecord
  validates_presence_of :title, :druid, :active, :embargo_months
  validates :druid, format: { with: /druid:.+/,
                                    message: "must begin with druid:" }
end
