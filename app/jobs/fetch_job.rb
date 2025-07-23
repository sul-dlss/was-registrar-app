# frozen_string_literal: true

# Retrieve the WARCs for the given month, register an item, and kick off accessioning workflow
class FetchJob < ApplicationJob
  include Registering
  queue_as :default

  rescue_from(StandardError) do |exception|
    failure_status(fetch_month, exception)
    raise exception
  end

  attr_reader :fetch_month

  def perform(fetch_month) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @fetch_month = fetch_month
    Honeybadger.context({ collection: fetch_month.collection.druid,
                          fetch_month: fetch_month.id })
    running_status(fetch_month)
    fetch_warcs
    return success_status(fetch_month) unless web_archives?(fetch_month.crawl_directory)

    cocina_obj = register(request_params)
    start_workflow(cocina_obj.externalIdentifier, cocina_obj.version)
    success_status(fetch_month, druid: cocina_obj.externalIdentifier)
  rescue StandardError => e
    raise "Fetching WARCs failed: #{e.message}"
  end

  def fetch_warcs # rubocop:disable Metrics/AbcSize
    client = WasapiClient.new(username: fetch_month.wasapi_account_config.username,
                              password: fetch_month.wasapi_account_config.password)
    client.fetch_warcs(collection: fetch_month.collection.wasapi_collection_id,
                       crawl_start_after: fetch_month.crawl_start_after,
                       crawl_start_before: fetch_month.crawl_start_before,
                       output_dir: fetch_month.crawl_directory)
  end

  def request_params
    RequestBuilder.build(title: fetch_month.job_directory,
                         source_id: fetch_month.source_id,
                         admin_policy: fetch_month.collection.admin_policy,
                         collection: fetch_month.collection.druid,
                         crawl_directory: fetch_month.crawl_directory)
  end
end
