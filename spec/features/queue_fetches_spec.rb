# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Queue fetch jobs for a collection', js: true do
  let!(:collection) { create(:ar_collection) }

  before do
    allow(JobLister).to receive(:list).and_return([])
    allow(FetchJobCreator).to receive(:run)
  end

  it 'initiates the fetches' do
    visit '/'
    click_link collection.title
    expect(page).to have_content 'Edit'

    click_button 'Queue fetch jobs'
    expect(page).to have_content 'Queued new fetch jobs.'
    expect(FetchJobCreator).to have_received(:run).with(collection:)
  end
end
