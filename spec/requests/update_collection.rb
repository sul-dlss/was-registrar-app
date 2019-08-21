# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Update collection information', type: :request do
  context 'and all steps in the current version are complete' do
    let(:collection) { create(:collection) }
    let(:druid) { collection.druid }

    it 'updates the information' do
      put "/collections/#{druid}", params: { title: 'Fast cars' }, as: :json
      expect(collection.reload.title).to eq 'Fast cars'
    end
  end
end
