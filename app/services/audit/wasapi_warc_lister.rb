# frozen_string_literal: true

module Audit
  # Enumberable that returns WARC filenames for a collection from a WASAPI provider.
  class WasapiWarcLister
    include Enumerable
    def initialize(wasapi_collection_id:, wasapi_provider:, wasapi_account:, embargo_months: 0)
      @wasapi_collection_id = wasapi_collection_id
      @wasapi_provider = wasapi_provider
      @wasapi_account = wasapi_account
      @embargo_months = embargo_months
    end

    def each(&block)
      if block_given?
        next_url = first_page_url
        while next_url
          response = get_page(next_url)
          files_for(response).each { |file| block.call(file) }
          next_url = response[:next]
        end
      else
        to_enum(:each)
      end
    end

    private

    attr_reader :wasapi_collection_id, :wasapi_provider, :wasapi_account, :embargo_months

    def wasapi_provider_config
      Settings.wasapi_providers[wasapi_provider]
    end

    def wasapi_account_config
      wasapi_provider_config.accounts[wasapi_account]
    end

    def first_page_url
      # crawl-start-before should be beginning of the month - embargo months.
      "#{wasapi_provider_config.baseurl}webdata?collection=#{wasapi_collection_id}&crawl-start-before=#{before_date}"
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.request :authorization, :basic, wasapi_account_config.username,
                     wasapi_account_config.password
      end
    end

    def get_page(url)
      response = connection.get(url) do |request|
        request.headers = { 'Content-Type' => 'application/json' }
      end

      raise "Getting #{url} returned #{response.status}" unless response.success?

      JSON.parse(response.body).with_indifferent_access
    end

    def files_for(response)
      response[:files].pluck(:filename)
    end

    def before_date
      (Time.zone.today - embargo_months.months).strftime('%Y-%m-01')
    end
  end
end
