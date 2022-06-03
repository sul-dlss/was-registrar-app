# frozen_string_literal: true

desc 'Audit accessioned WARCs against WARCs available from WASAPI provider'
task :audit, %i[collection_druid] => :environment do |_task, args|
  collection = Collection.find_by(druid: args[:collection_druid])
  puts "Auditing #{collection.title}. This might take a minute."
  puts Audit::WarcAuditer.audit(collection_druid: collection.druid,
                                wasapi_collection_id: collection.wasapi_collection_id,
                                wasapi_account: collection.wasapi_account,
                                wasapi_provider: collection.wasapi_provider)
end
