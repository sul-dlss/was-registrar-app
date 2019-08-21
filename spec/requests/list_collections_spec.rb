# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List collections', type: :request do
  before do
    create(:collection, title: 'zzz collection')
    create(:collection, title: 'aaa collection')
  end

  it 'shows the information' do
    get collections_path
    expect(response.body).to match 'zzz collection'
    expect(response.body).to match 'aaa collection'
  end
end
