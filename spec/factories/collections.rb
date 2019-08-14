# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    sequence :druid do |n|
      "druid:abc123#{n}"
    end
    active { true }
    embargo_months { 6 }
  end
end
