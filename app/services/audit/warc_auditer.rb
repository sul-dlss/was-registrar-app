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
      WasapiWarcLister.new(wasapi_collection_id:, wasapi_provider:,
                           wasapi_account:, embargo_months:).to_a
    end

    def sdr_warc_filenames
      SdrWarcLister.new(collection_druid:).to_a
    end
  end
end
