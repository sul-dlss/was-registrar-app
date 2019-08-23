# frozen_string_literal: true

FactoryBot.define do
  factory :fetch_month do
    year { 2017 }
    month { 11 }
    status { 'waiting' }
  end
end
