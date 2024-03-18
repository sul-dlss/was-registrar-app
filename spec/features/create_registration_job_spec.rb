# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create a registration job', :js do
  before do
    allow(JobLister).to receive(:list).and_return([])
  end

  context 'when fields are missing' do
    it 'shows the errors' do
      visit root_path
      click_link 'Create a one-time registration'
      click_button 'Create Registration job'

      expect(page).to have_content "Job directory can't be blank"
      expect(page).to have_content "Collection can't be blank and Collection must be a " \
                                   'valid druid beginning with druid:'
      expect(page).to have_content "Source can't be blank and Source must be namespace:identifier"
    end
  end

  context 'when all fields are present' do
    before do
      allow(RegisterJob).to receive(:perform_later)
    end

    it 'creates the registration job and starts job' do
      visit root_path
      click_link 'Create a one-time registration'

      fill_in 'Job directory', with: ' AIT_123 ' # Intentionally has extra spaces to test stripping
      fill_in 'Collection Druid', with: 'druid:dm081mp8068'
      fill_in 'Source ID', with: 'sul:AIT_123'
      click_button 'Create Registration job'

      expect(page).to have_content 'Queueing one-time registration.'
      expect(RegistrationJob.exists?(job_directory: 'AIT_123')).to be true
      expect(RegisterJob).to have_received(:perform_later)
    end
  end

  context 'when cancelling' do
    it 'returns to root page' do
      visit root_path
      click_link 'Create a one-time registration'
      click_link 'Cancel'
      expect(page).to have_current_path(root_path)
    end
  end
end
