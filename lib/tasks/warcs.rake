# frozen_string_literal: true

require 'csv'

desc 'List WARC files for a given collection id'
task :warcs, %i[druid] => :environment do |_task, args|
  collection = Collection.find_by!(druid: args[:druid])

  warc_lister = Audit::WasapiWarcLister.new(
    wasapi_provider: collection.wasapi_provider,
    wasapi_account: collection.wasapi_account,
    wasapi_collection_id: collection.wasapi_collection_id
  )

  CSV do |csv|
    csv << %w[filename md5 sha1 bytes crawl_time crawl_start store_time url]
    warc_lister.each do |file|
      csv << [
        file.filename,
        file.md5,
        file.sha1,
        file.bytes,
        file.crawl_time,
        file.crawl_start,
        file.store_time,
        file.url
      ]
    end
  end
end
