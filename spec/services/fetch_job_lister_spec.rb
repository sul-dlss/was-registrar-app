# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchJobLister do
  let(:collection) { create(:collection) }
  let(:fetch_month) { create(:fetch_month, collection: collection) }

  subject(:fetch_months) { described_class.list }

  context 'when there are no current jobs' do
    before do
      allow(Sidekiq::Workers).to receive(:new).and_return([])
    end

    it 'returns no FetchMonths' do
      expect(fetch_months).to be_empty
    end
  end

  context 'when there are current jobs' do
    let(:workers) { instance_double(Sidekiq::Workers) }
    let(:work) do
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
      }
    end

    before do
      allow(Sidekiq::Workers).to receive(:new).and_return(workers)
      allow(workers).to receive(:map).and_return([nil, work])
    end

    it 'returns FetchMonths for those jobs' do
      expect(fetch_months).to eq([fetch_month])
    end
  end
end
