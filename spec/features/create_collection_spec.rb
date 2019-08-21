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
    end
  end

  context 'when all fields are present' do
    it 'shows the errors' do
      visit '/collections'
      click_link 'Add a Collection'

      fill_in 'Title', with: 'Robots'
      fill_in 'Druid', with: "druid:#{rand(10_000)}"
      fill_in 'Fetch start month', with: '2011-08-01'
      check 'collection_active'
      click_button 'Create Collection'

      expect(page).to have_content 'Collection created.'
    end
  end
end
