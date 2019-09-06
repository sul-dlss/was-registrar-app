# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List collections', type: :request do
  before do
    create(:collection, title: 'zzz collection')
    create(:collection, title: 'aaa collection')
    allow(FetchJobLister).to receive(:list).and_return([])
  end

  it 'shows the information' do
    get '/collections'
    expect(response.body).to include 'Collections'
    expect(response.body).to include 'zzz collection'
    expect(response.body).to include 'aaa collection'
  end
end
