# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchJobCreator do
  subject(:run) { described_class.run(collection:) }

  before do
    allow(Date).to receive(:today).and_return(Date.parse('2019-08-21'))
    allow(FetchJob).to receive(:perform_later)
  end

  context 'when there is an embargo' do
    let(:collection) do
      create(:ar_collection, fetch_start_month: '2018-10-01')
    end

    context 'with a collection that has fetch months' do
      before do
        collection.fetch_months.create!(year: 2018, month: 11, status: 'waiting')
      end

      it 'creates fetch_months' do
        run
        expect(collection.fetch_months.map { |m| [m.year, m.month] }).to eq [
          [2018, 11], [2018, 12], [2019, 1]
        ]
        # 2018-11 already exists, so won't be performed here.
        expect(FetchJob).to have_received(:perform_later).exactly(2).times
      end
    end

    context 'with a collection that does not have fetch months' do
      it 'creates fetch_months' do
        run
        expect(collection.fetch_months.map { |m| [m.year, m.month] }).to eq [
          [2018, 10], [2018, 11], [2018, 12], [2019, 1]
        ]
        expect(FetchJob).to have_received(:perform_later).exactly(4).times
      end
    end
  end

  context 'when there is minimum embargo' do
    let(:collection) do
      create(:ar_collection, embargo_months: 1, fetch_start_month: '2018-10-01')
    end

    context 'with a collection that has fetch months' do
      before do
        collection.fetch_months.create!(year: 2018, month: 11, status: 'waiting')
      end

      it 'creates fetch_months' do
        run
        expect(collection.fetch_months.map { |m| [m.year, m.month] }).to eq [
          [2018, 11], [2018, 12], [2019, 1], [2019, 2], [2019, 3], [2019, 4], [2019, 5], [2019, 6]
        ]
        # 2018-11 already exists, so won't be performed here.
        expect(FetchJob).to have_received(:perform_later).exactly(7).times
      end
    end

    context 'with a collection that does not have fetch months' do
      it 'creates fetch_months' do
        run
        expect(collection.fetch_months.map { |m| [m.year, m.month] }).to eq [
          [2018, 10], [2018, 11], [2018, 12], [2019, 1], [2019, 2], [2019, 3], [2019, 4], [2019, 5], [2019, 6]
        ]
        expect(FetchJob).to have_received(:perform_later).exactly(9).times
      end
    end
  end
end
