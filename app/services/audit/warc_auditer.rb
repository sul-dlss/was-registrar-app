# frozen_string_literal: true

module Audit
  # Audits accessioned WARCs against WARCs available from a WASAPI provider.
  class WarcAuditer
    # @return [Array<String>] filenames that are available from WASAPI provider but have not been accessioned
    def self.audit(collection_druid:, wasapi_collection_id:, wasapi_account:, wasapi_provider: 'ait', embargo_months: 0)
      new(collection_druid:, wasapi_collection_id:,
          wasapi_account:, wasapi_provider:, embargo_months:).audit
    end

    # @return [Array<String>] filenames that are available from WASAPI provider but have not been accessioned
    def self.audit_collection(collection:)
      audit(collection_druid: collection.druid,
            wasapi_collection_id: collection.wasapi_collection_id,
            wasapi_account: collection.wasapi_account,
            wasapi_provider: collection.wasapi_provider,
            embargo_months: collection.embargo_months)
    end

    def initialize(collection_druid:, wasapi_collection_id:, wasapi_account:, wasapi_provider:, embargo_months:)
      @collection_druid = collection_druid
      @wasapi_collection_id = wasapi_collection_id
      @wasapi_account = wasapi_account
      @wasapi_provider = wasapi_provider
      @embargo_months = embargo_months
    end

    def audit
      wasapi_warc_filenames - sdr_warc_filenames
    end

    private

    attr_reader :collection_druid, :wasapi_collection_id, :wasapi_account, :wasapi_provider, :embargo_months

    def wasapi_warc_filenames
      client = WasapiClient.new(username: wasapi_account_config.username,
                                password: wasapi_account_config.password)
      client.filenames(collection: wasapi_collection_id, crawl_start_before: before_date)
    end

    def sdr_warc_filenames
      SdrWarcLister.new(collection_druid:).to_a
    end

    def before_date
      (Time.zone.today - embargo_months.months).strftime('%Y-%m-01')
    end

    def wasapi_provider_config
      Settings.wasapi_providers[wasapi_provider]
    end

    def wasapi_account_config
      wasapi_provider_config.accounts[wasapi_account]
    end
  end
end
