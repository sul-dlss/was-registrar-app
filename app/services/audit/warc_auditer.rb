# frozen_string_literal: true

module Audit
  # Audits accessioned WARCs against WARCs available from a WASAPI provider.
  class WarcAuditer
    # @return [Array<String>] filenames that are available from WASAPI provider but have not been accessioned
    def self.audit(collection_druid:, wasapi_collection_id:, wasapi_account:, wasapi_provider: 'ait', embargo_months: 0)
      new(collection_druid: collection_druid, wasapi_collection_id: wasapi_collection_id,
          wasapi_account: wasapi_account, wasapi_provider: wasapi_provider, embargo_months: embargo_months).audit
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
      WasapiWarcLister.new(wasapi_collection_id: wasapi_collection_id, wasapi_provider: wasapi_provider,
                           wasapi_account: wasapi_account, embargo_months: embargo_months).to_a
    end

    def sdr_warc_filenames
      SdrWarcLister.new(collection_druid: collection_druid).to_a
    end
  end
end
