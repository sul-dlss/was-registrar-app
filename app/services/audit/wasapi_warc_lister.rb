# frozen_string_literal: true

module Audit
  # Enumberable that returns WARC filenames for a collection from a WASAPI provider.
  class WasapiWarcLister
    include Enumerable
    def initialize(wasapi_collection_id:, wasapi_provider:, wasapi_account:)
      @wasapi_collection_id = wasapi_collection_id
      @wasapi_provider = wasapi_provider
      @wasapi_account = wasapi_account
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

    attr_reader :wasapi_collection_id, :wasapi_provider, :wasapi_account

    def wasapi_provider_config
      Settings.wasapi_providers[wasapi_provider]
    end

    def wasapi_account_config
      wasapi_provider_config.accounts[wasapi_account]
    end

    def first_page_url
      "#{wasapi_provider_config.baseurl}webdata?collection=#{wasapi_collection_id}"
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
  end
end
