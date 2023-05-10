# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchJobRetrier do
  let(:retrier) { described_class.new(collection.id) }

  let(:collection) { create(:ar_collection, wasapi_collection_id: '915') }

  before do
    allow(FetchJob).to receive(:perform_later)
  end

  context 'when no fetch months' do
    it 'does not have retriable months' do
      expect(retrier.retry?).to be false
    end

    it 'does not retry' do
      retrier.retry
      expect(FetchJob).not_to have_received(:perform_later)
    end
  end

  context 'when no last registered fetch month' do
    let!(:success_fetch_month) { create(:fetch_month, collection:, status: 'success') }
    let!(:failure_fetch_month) { create(:fetch_month, collection:, status: 'failure') }
    let!(:waiting_fetch_month) { create(:fetch_month, collection:, status: 'waiting') }
    let!(:running_fetch_month) { create(:fetch_month, collection:, status: 'waiting') }

    it 'has retriable months' do
      expect(retrier.retry?).to be true
    end

    it 'retries retriable months' do
      retrier.retry
      expect(FetchJob).not_to have_received(:perform_later).with([success_fetch_month, failure_fetch_month])
    end
  end

  context 'when last registered fetch month' do
    let!(:previous_success_fetch_month) { create(:fetch_month, collection:, status: 'success') }
    let!(:last_registered_fetch_month) do
      create(:fetch_month, collection:, status: 'success', crawl_item_druid: 'druid:abc123')
    end
    let!(:success_fetch_month) { create(:fetch_month, collection:, status: 'success') }
    let!(:failure_fetch_month) { create(:fetch_month, collection:, status: 'failure') }
    let!(:waiting_fetch_month) { create(:fetch_month, collection:, status: 'waiting') }
    let!(:running_fetch_month) { create(:fetch_month, collection:, status: 'waiting') }

    it 'has retriable months' do
      expect(retrier.retry?).to be true
    end

    it 'retries retriable months' do
      retrier.retry
      expect(FetchJob).not_to have_received(:perform_later).with([success_fetch_month, failure_fetch_month])
    end
  end
end
