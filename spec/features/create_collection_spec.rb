# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create a collection', type: :feature do
  context 'when fields are missing' do
    it 'shows the errors' do
      visit '/collections'
      click_link 'Add a Collection'
      click_button 'Create Collection'

      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Druid can't be blank and Druid must begin with druid:"
      expect(page).to have_content "Wasapi provider account can't be blank"
    end
  end

  context 'when all fields are present' do
    it 'shows the errors' do
      visit '/collections'
      click_link 'Add a Collection'

      fill_in 'Title', with: 'Robots'
      fill_in 'Druid', with: "druid:#{rand(10_000)}"
      select 'August', from: 'collection_fetch_start_month_2i'
      select '2011', from: 'collection_fetch_start_month_1i'
      select 'Archive-It (ait) > 1 (ua)', from: 'WASAPI provider / account'
      check 'collection_active'
      click_button 'Create Collection'

      expect(page).to have_content 'Collection created.'
    end
  end
end
