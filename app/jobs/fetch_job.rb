# frozen_string_literal: true

require 'open3'

# Retrieve the WARCs for the given month and kick off accessioning workflow
class FetchJob < ApplicationJob
  queue_as :default

  attr_reader :fetch_month

  def perform(fetch_month)
    @fetch_month = fetch_month
    fetch_month.update(status: 'running', failure_reason: nil)
    FileUtils.mkdir_p(fetch_month.crawl_directory)
    fetch_warcs
    return success unless warcs?

    druid = register
    start_workflow(druid)
    success(druid: druid)
  end

  def fetch_warcs
    _, stderr, status = Open3.capture3(Settings.wasapi_downloader_bin, *downloader_args)
    return if status.success?

    failure_reason = "Fetching WARCs failed: #{stderr}"
    fetch_month.update(failure_reason: failure_reason, status: 'failure')
    raise failure_reason
  end

  # rubocop:disable Metrics/AbcSize
  def downloader_args
    ['--crawlStartAfter', fetch_month.crawl_start_after,
     '--crawlStartBefore', fetch_month.crawl_start_before,
     '--baseurl', fetch_month.wasapi_provider_config.baseurl,
     '--authurl', fetch_month.wasapi_provider_config.authurl,
     '--username', fetch_month.wasapi_account_config.username,
     '--password', fetch_month.wasapi_account_config.password,
     '--outputBaseDir', fetch_month.crawl_directory + '/',
     '--collectionId', fetch_month.collection.wasapi_collection_id,
     '--resume']
  end
  # rubocop:enable Metrics/AbcSize

  def warcs?
    Dir.glob("#{fetch_month.crawl_directory}/**/*.warc*").any?
  end

  def workflow_client
    @workflow_client ||= Dor::Workflow::Client.new(url: Settings.workflow.url)
  end

  def register
    register_params = { object_type: 'item',
                        admin_policy: fetch_month.collection.admin_policy,
                        source_id: source_id,
                        label: fetch_month.job_directory,
                        collection: fetch_month.collection_id,

                        rights: 'dark' }
    response = Dor::Services::Client.objects.register(params: register_params)

    response[:pid]
  end

  def start_workflow(druid)
    workflow_client.create_workflow_by_name(druid, 'wasCrawlPreassemblyWF')
  end

  def success(druid: nil)
    fetch_month.update(crawl_item_druid: druid, status: 'success', failure_reason: nil)
  end

  def source_id
    # sul:[wasapi provider]-[collectionId]-[YYYY]_[MM]
    date_part = "#{fetch_month.year}_#{fetch_month.month.to_s.rjust(2, '0')}"
    "sul:#{fetch_month.collection.wasapi_provider}-#{fetch_month.collection.wasapi_collection_id}-#{date_part}"
  end
end
