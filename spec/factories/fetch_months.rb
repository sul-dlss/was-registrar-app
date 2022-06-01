# frozen_string_literal: true

FactoryBot.define do
  factory :fetch_month do
    sequence(:year, 2020)
    month { 11 }
    status { 'waiting' }
  end
end
