# frozen_string_literal: true

class Collection < ApplicationRecord
  validates_presence_of :title, :druid
end
