# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchMonth, type: :model do
  let(:collection) { create(:ar_collection, wasapi_collection_id: '915') }
  let(:fetch_month) { create(:fetch_month, collection: collection, crawl_item_druid: 'druid:abc123', year: 2017) }

  describe '#crawl_directory' do
    it 'returns the correct crawl directory' do
      expect(fetch_month.crawl_directory).to eq('spec/fixtures/jobs/AIT_915/2017_11')
    end
  end

  describe '#job_directory' do
    it 'returns the correct job directory' do
      expect(fetch_month.job_directory).to eq('AIT_915/2017_11')
    end

    context 'when the month is a single digit' do
      let(:fetch_month) { create(:fetch_month, collection: collection, month: 1, year: 2017) }

      it 'returns the correct job directory with month padded' do
        expect(fetch_month.job_directory).to eq('AIT_915/2017_01')
      end
    end
  end

  describe 'crawl_item_druid' do
    it 'returns the fetch crawl item druid' do
      expect(fetch_month.crawl_item_druid).to eq('druid:abc123')
    end
  end

  describe '#crawl_start_after' do
    it 'returns the fetch month' do
      expect(fetch_month.crawl_start_after).to eq('2017-11-01')
    end
  end

  describe '#crawl_start_before' do
    it 'returns the fetch month + 1' do
      expect(fetch_month.crawl_start_before).to eq('2017-12-01')
    end
  end

  describe '#wasapi_provider_config' do
    it 'provides the correct config' do
      expect(fetch_month.wasapi_provider_config.name).to eq('Archive-It')
    end
  end

  describe '#wasapi_account_config' do
    it 'provides the correct config' do
      expect(fetch_month.wasapi_account_config.username).to eq('user')
    end
  end
end
