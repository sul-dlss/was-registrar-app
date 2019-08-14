# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Collection information', type: :request do
  context 'and all steps in the current version are complete' do
    let(:collection) { create(:collection, title: 'SLAC Webpage') }
    let(:druid) { collection.druid }
    let(:headers) do
      { 'ACCEPT' => 'application/json' }
    end

    it 'shows the information' do
      get "/collections/#{druid}", headers: headers
      json = JSON.parse(response.body)
      expect(json['title']).to eq 'SLAC Webpage'
    end
  end
end
