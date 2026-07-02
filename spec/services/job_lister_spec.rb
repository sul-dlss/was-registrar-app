# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobLister do
  subject(:fetch_months) { described_class.list }

  let(:collection) { create(:ar_collection) }
  let(:fetch_month) { create(:fetch_month, collection:) }

  context 'when there are no current jobs' do
    before do
      allow(Sidekiq::Workers).to receive(:new).and_return([])
    end

    it 'returns no FetchMonths' do
      expect(fetch_months).to be_empty
    end
  end

  context 'when there are current jobs' do
    let(:payload) do
      gid = "gid://was-registrar-app/FetchMonth/#{fetch_month.id}"
      {
        'args' => [
          { 'arguments' =>
                 [
                   {
                     '_aj_globalid' => gid
                   }
                 ] }
        ]
      }.to_json
    end
    let(:sidekiq_work) { Sidekiq::Work.new('pid', 'tid', { 'payload' => payload, 'queue' => 'default', 'run_at' => Time.now.to_i }) }

    before do
      allow(Sidekiq::Workers).to receive(:new).and_return([['pid', 'tid', sidekiq_work]])
    end

    it 'returns FetchMonths for those jobs' do
      expect(fetch_months).to eq([fetch_month])
    end
  end
end
