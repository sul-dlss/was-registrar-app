# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Retry fetches' do
  let(:collection) { create(:ar_collection) }

  context 'when no retriable fetch months' do
    it 'does not render button' do
      visit edit_collection_path(collection)
      expect(page).to have_content "Edit #{collection.title}"
      expect(page).to have_button 'Queue fetch jobs'
      expect(page).not_to have_button 'Retry fetch jobs'
    end
  end

  context 'when retriable fetch months' do
    let!(:fetch_month) { create(:fetch_month, collection:, status: 'success') }

    before do
      allow(FetchJobRetrier).to receive(:retry)
    end

    it 'allows retrying' do
      visit edit_collection_path(collection)
      expect(page).to have_content "Edit #{collection.title}"

      click_button 'Retry fetch jobs'

      expect(page).to have_content "Edit #{collection.title}"
      expect(page).to have_content 'Queued retry fetch jobs.'
      expect(FetchJobRetrier).to have_received(:retry).with(collection:)
    end
  end
end
