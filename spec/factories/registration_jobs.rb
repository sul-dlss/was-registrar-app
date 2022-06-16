# frozen_string_literal: true

FactoryBot.define do
  factory :registration_job do
    sequence :job_directory do |_n|
      'crawl{n}'
    end
    collection { 'druid:bf172jb9970' }
    sequence :source_id do |_n|
      'sul:crawl{n}'
    end
  end
end
