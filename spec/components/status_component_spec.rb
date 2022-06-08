# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StatusComponent do
  subject(:component) { described_class.new(status_obj: fetch_month) }

  describe '#status' do
    subject(:status) { component.status }

    context 'when status is successful' do
      let(:fetch_month) { build(:fetch_month, status: 'success') }

      context 'when no WARCs were fetched' do
        it { is_expected.to eq 'success: No WARCs' }
      end

      context 'when a WARC was fetched' do
        before do
          fetch_month.crawl_item_druid = 'druid:1234'
        end

        it {
          expect(status).to eq 'success: Created <a target="_new" href="https://argo.stanford.edu/view/druid:1234">druid:1234</a>'
        }
      end
    end

    context 'when status is running' do
      let(:fetch_month) { build(:fetch_month, status: 'running') }

      it { is_expected.to eq 'running' }
    end

    context 'when status is failure' do
      let(:fetch_month) { build(:fetch_month, status: 'failure', failure_reason: 'broken!') }

      it { is_expected.to eq 'failure: broken!' }
    end
  end
end
