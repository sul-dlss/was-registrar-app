# frozen_string_literal: true

require 'open3'

# Retrieve the WARCs for the given month, register an item, and kick off accessioning workflow
class FetchJob < ApplicationJob
  include Registering
  queue_as :default

  rescue_from(StandardError) do |exception|
    failure_status(fetch_month, exception)
    raise exception
  end

  attr_reader :fetch_month

  def perform(fetch_month)
    @fetch_month = fetch_month
    running_status(fetch_month)
    FileUtils.mkdir_p(fetch_month.crawl_directory)
    fetch_warcs
    return success_status(fetch_month) unless web_archives?(fetch_month.crawl_directory)

    cocina_obj = register(request_params)
    start_workflow(cocina_obj.externalIdentifier, cocina_obj.version)
    success_status(fetch_month, druid: cocina_obj.externalIdentifier)
  end

  def fetch_warcs
    _, stderr, status = Open3.capture3(Settings.wasapi_downloader_bin, *downloader_args)
    return if status.success?

    raise "Fetching WARCs failed: #{stderr}"
  end

  # rubocop:disable Metrics/AbcSize
  def downloader_args
    ['--crawlStartAfter', fetch_month.crawl_start_after,
     '--crawlStartBefore', fetch_month.crawl_start_before,
     '--baseurl', fetch_month.wasapi_provider_config.baseurl,
     '--authurl', fetch_month.wasapi_provider_config.authurl,
     '--username', fetch_month.wasapi_account_config.username,
     '--password', fetch_month.wasapi_account_config.password,
     '--outputBaseDir', "#{fetch_month.crawl_directory}/",
     '--collectionId', fetch_month.collection.wasapi_collection_id,
     '--resume']
  end
  # rubocop:enable Metrics/AbcSize

  def request_params
    RequestBuilder.build(title: fetch_month.job_directory,
                         source_id: fetch_month.source_id,
                         admin_policy: fetch_month.collection.admin_policy,
                         collection: fetch_month.collection.druid,
                         crawl_directory: fetch_month.crawl_directory)
  end
end
