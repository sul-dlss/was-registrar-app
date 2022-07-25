# frozen_string_literal: true

desc 'Audit accessioned WARCs against WARCs available from WASAPI provider for a collection'
task :audit_collection, %i[collection_druid] => :environment do |_task, args|
  collection = Collection.find_by(druid: args[:collection_druid])
  puts "Auditing #{collection.title}. This might take a minute."
  puts Audit::WarcAuditer.audit_collection(collection: collection)
end

desc 'Audit accessioned WARCs against WARCs available from AIT WASAPI provider'
task :audit,
     %i[collection_druid wasapi_collection_id wasapi_account
        embargo_months] => :environment do |_task, args|
  puts "Auditing #{args[:collection_druid]}. This might take a minute."
  puts Audit::WarcAuditer.audit(collection_druid: args[:collection_druid],
                                wasapi_collection_id: args[:wasapi_collection_id],
                                wasapi_account: args[:wasapi_account],
                                embargo_months: args[:embargo_months].to_i)
end

desc 'Remediate missing WARCs based on audit results for a collection'
task :remediate_collection, %i[collection_druid] => :environment do |_task, args|
  collection = Collection.find_by(druid: args[:collection_druid])
  puts "Auditing #{collection.title}. This might take a minute."
  filenames = Audit::WarcAuditer.audit_collection(collection: collection)
  if filenames.empty?
    puts 'Nothing to remediate.'
    next
  end

  puts 'Missing files:'
  puts filenames
  puts 'Remediating. This might take a minute.'
  job_directory = Audit::WarcRemediator.remediate_collection(collection: collection)
  puts "Job directory: #{job_directory}"
end

desc 'Remediate missing WARCs based on audit results for AIT'
task :remediate,
     %i[collection_druid wasapi_collection_id wasapi_account
        embargo_months] => :environment do |_task, args|
  collection = Collection.find_by(druid: args[:collection_druid])
  puts "Auditing #{collection.title}. This might take a minute."
  filenames = Audit::WarcAuditer.audit(collection_druid: args[:collection_druid],
                                       wasapi_collection_id: args[:wasapi_collection_id],
                                       wasapi_account: args[:wasapi_account],
                                       embargo_months: args[:embargo_months].to_i)
  if filenames.empty?
    puts 'Nothing to remediate.'
    next
  end

  puts 'Missing files:'
  puts filenames
  puts 'Remediating. This might take a minute.'
  job_directory = Audit::WarcRemediator.remediate(
    collection_druid: args[:collection_druid],
    wasapi_collection_id: args[:wasapi_collection_id],
    wasapi_account: args[:wasapi_account],
    filenames: filenames
  )
  puts "Job directory: #{job_directory}"
end
