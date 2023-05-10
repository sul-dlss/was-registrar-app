# frozen_string_literal: true

desc 'Initiate FetchJobs for all active collections'
task fetch_collections: :environment do
  Collection.active.each do |collection|
    FetchJobCreator.run(collection:)
  end
end
