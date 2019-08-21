# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'collections/index' do
  let(:collection1) { create(:collection, title: 'collection1', druid: 'druid:1') }
  let(:collection2) { create(:collection, title: 'collection2', druid: 'druid:2') }

  it 'displays all the collections' do
    @collections = [collection1, collection2]

    render

    expect(rendered).to match(/collection1/)
    expect(rendered).to match(/druid:1/)
    expect(rendered).to match(/on/)
    expect(rendered).to match(/collection2/)
  end
end
