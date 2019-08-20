# frozen_string_literal: true

# This represents fetching a particular collection for a particular month
class FetchMonth < ApplicationRecord
  belongs_to :collection
  validates :status, inclusion: { in: %w[waiting running success failure] }
end
