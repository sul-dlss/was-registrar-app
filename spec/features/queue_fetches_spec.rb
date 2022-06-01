# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Queue fetch jobs for a collection', type: :feature do
  let(:collection) { create(:collection) }

  before do
    allow(FetchJobLister).to receive(:list).and_return([])
    allow(FetchJobCreator).to receive(:run).with(collection: collection)
  end

  it 'initiates the fetches' do
    visit '/collections'
    click_link collection.title
    expect(page).to have_content 'Edit'

    click_button 'Queue fetch jobs'
    expect(FetchJobCreator).to have_received(:run).with(collection: collection)
    expect(page).to have_content 'Queued new fetch jobs.'
  end
end
