# frozen_string_literal: true

# Administrative Policy
class AdminPolicy < ApplicationRecord
  self.primary_key = 'druid'

  belongs_to :collection
  validates :druid, :name, presence: true
end
