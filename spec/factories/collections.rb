# frozen_string_literal: true

FactoryBot.define do
  factory :ar_collection, class: 'Collection' do
    sequence :title do |n|
      "Test title ##{n}"
    end

    sequence :druid do |n|
      "druid:bc123df#{n.to_s.rjust(4, '0')}"
    end
    active { true }
    embargo_months { 6 }
    fetch_start_month { '2011-08-01' }
    wasapi_provider { 'ait' }
    wasapi_account { 'ua' }
    sequence :wasapi_collection_id, &:to_s
  end
end
