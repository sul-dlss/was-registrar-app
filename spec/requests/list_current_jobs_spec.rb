# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List current jobs' do
  let(:collection) { create(:ar_collection) }
  let(:registration_job) { create(:registration_job) }
  let(:fetch_month) { create(:fetch_month, collection:) }

  context 'when there are no jobs' do
    before do
      allow(JobLister).to receive(:list).and_return([])
    end

    it 'indicates no jobs' do
      get '/'
      expect(response.body).to include 'Running jobs'
      expect(response.body).to include 'No jobs are currently processing.'
    end
  end

  context 'when there are jobs' do
    before do
      allow(JobLister).to receive(:list).and_return([fetch_month, registration_job])
    end

    it 'lists the jobs' do
      get '/'
      expect(response.body).to include 'Running jobs'
      expect(response.body).not_to include 'No jobs are currently processing.'
      expect(response.body).to include 'November'
      expect(response.body).to include 'sul:crawl'
    end
  end
end
