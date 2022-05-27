# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List current jobs', type: :request do
  let(:collection) { create(:ar_collection) }
  let(:fetch_month) { create(:fetch_month, collection: collection) }

  context 'when there are no jobs' do
    before do
      allow(FetchJobLister).to receive(:list).and_return([])
    end

    it 'indicates no jobs' do
      get '/collections'
      expect(response.body).to include 'Current jobs'
      expect(response.body).to include 'No jobs'
    end
  end

  context 'when there are jobs' do
    before do
      allow(FetchJobLister).to receive(:list).and_return([fetch_month])
    end

    it 'lists the jobs' do
      get '/collections'
      expect(response.body).to include 'Current jobs'
      expect(response.body).not_to include 'No jobs'
      expect(response.body).to include 'November'
    end
  end
end
