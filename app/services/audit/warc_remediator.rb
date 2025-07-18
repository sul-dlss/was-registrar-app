# frozen_string_literal: true

module Audit
  # Retrieves WARC files from a WASAPI provider and initiates one-time registration.
  class WarcRemediator
    # @return [String] job directory
    def self.remediate(collection_druid:, wasapi_collection_id:, wasapi_account:, filenames:, source_id: nil,
                       admin_policy_druid: 'druid:wr005wn5739', wasapi_provider: 'ait')
      new(collection_druid:, source_id:, admin_policy_druid:,
          wasapi_collection_id:, wasapi_account:, wasapi_provider:,
          filenames:).remediate
    end

    # @return [String] job directory
    def self.remediate_collection(collection:, filenames:)
      remediate(collection_druid: collection.druid,
                wasapi_collection_id: collection.wasapi_collection_id,
                wasapi_account: collection.wasapi_account,
                wasapi_provider: collection.wasapi_provider,
                filenames:)
    end

    def initialize(collection_druid:, admin_policy_druid:, wasapi_collection_id:, wasapi_account:, wasapi_provider:,
                   filenames:, source_id: nil)
      @collection_druid = collection_druid
      @admin_policy_druid = admin_policy_druid
      @wasapi_collection_id = wasapi_collection_id
      @wasapi_account = wasapi_account
      @wasapi_provider = wasapi_provider
      @filenames = filenames
      @job_id = "patch-missing-#{Time.zone.today.strftime('%Y_%m_%d')}"
      @source_id = source_id || "sul:#{wasapi_provider.upcase}-#{wasapi_collection_id}-#{@job_id}"
    end

    def remediate
      fetch
      register

      job_directory
    end

    private

    attr_reader :collection_druid, :source_id, :admin_policy_druid,
                :wasapi_collection_id, :wasapi_account, :wasapi_provider, :filenames, :job_id

    def job_directory
      @job_directory ||= File.join("#{wasapi_provider.upcase}_#{wasapi_collection_id}",
                                   job_id)
    end

    def crawl_directory
      @crawl_directory ||= File.join(Settings.crawl_directory, job_directory)
    end

    def fetch
      @client ||= WasapiClient.new(username: wasapi_account_config.username,
                                   password: wasapi_account_config.password)
      filenames.each { |filename| fetch_warc(filename) }
    end

    def fetch_warc(filename)
      FileUtils.mkdir_p(crawl_directory)
      @client.fetch_file(file: filename, output_dir: crawl_directory)
    rescue StandardError => e
      raise "Fetching WARC failed: #{e.message}"
    end

    def wasapi_provider_config
      @wasapi_provider_config ||= Settings.wasapi_providers[wasapi_provider]
    end

    def wasapi_account_config
      @wasapi_account_config ||= wasapi_provider_config.accounts[wasapi_account]
    end

    def register
      registration_job = RegistrationJob.create!(job_directory:, collection: collection_druid,
                                                 admin_policy: admin_policy_druid, source_id:)
      RegisterJob.perform_later(registration_job)
    end
  end
end
