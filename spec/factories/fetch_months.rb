# frozen_string_literal: true

FactoryBot.define do
  factory :fetch_month do
    collection { nil }
    year { 1 }
    month { 1 }
    status { 'MyString' }
    failure_reason { 'MyText' }
    crawl_item_druid { 'MyString' }
  end
end
