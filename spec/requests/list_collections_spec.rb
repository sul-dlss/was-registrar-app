# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List collections' do
  before do
    create(:ar_collection, title: 'zzz collection')
    create(:ar_collection, title: 'aaa collection')
  end

  it 'shows the information' do
    get '/collections'
    expect(response.body).to include 'Collections'
    expect(response.body).to include 'zzz collection'
    expect(response.body).to include 'aaa collection'
    expect(response.body).to include 'Add a Collection'
  end
end
