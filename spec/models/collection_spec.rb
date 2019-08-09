# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection, type: :model do
  let(:collection) do
    Collection.new do |collection|
      collection.title = 'My collection'
      collection.druid = 'druid:abc123'
      collection.active = true
      collection.embargo_months = 6
    end
  end

  context 'a valid collection' do
    it 'validates' do
      expect(collection.valid?).to eq(true)
    end
  end
  context 'an valid collection' do
    it 'validates title' do
      collection.title = nil
      expect(collection.valid?).to eq(false)
    end
    it 'validates druid' do
      collection.druid = 'abc123'
      expect(collection.valid?).to eq(false)
    end
    it 'validates active' do
      collection.active = nil
      expect(collection.valid?).to eq(false)
    end
    it 'validates embargo_months' do
      collection.embargo_months = nil
      expect(collection.valid?).to eq(false)
    end
  end
end
