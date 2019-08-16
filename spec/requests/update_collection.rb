# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update collection information', type: :request do
  context 'and all steps in the current version are complete' do
    let(:collection) { create(:collection) }
    let(:druid) { collection.druid }

    it 'updates the information' do
      put "/collections/#{druid}", params: { last_successful_fetch: '2019-08-16T11:31:00+06:00' }, as: :json
      expect(collection.reload.last_successful_fetch).to eq DateTime.parse('2019-08-16 05:31:00+0')
    end
  end
end
