# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection, type: :model do
  let(:collection) do
    build(:ar_collection, title: 'My collection', druid: 'druid:dm081mp8068')
  end

  before do
    create(:ar_collection, wasapi_collection_id: '916')
  end

  context 'with a valid collection' do
    it 'validates' do
      expect(collection.valid?).to be(true)
    end
  end

  context 'with an invalid collection' do
    it 'validates title' do
      collection.title = nil
      expect(collection.valid?).to be(false)
    end

    it 'validates druid must begin with druid' do
      collection.druid = 'abc123'
      expect(collection.valid?).to be(false)
    end

    it 'validates active' do
      collection.active = nil
      expect(collection.valid?).to be(false)
    end

    it 'validates embargo_months is present' do
      collection.embargo_months = nil
      expect(collection.valid?).to be(false)
    end

    it 'validates embargo_months is greater than 0' do
      collection.embargo_months = 0
      expect(collection.valid?).to be(false)
    end

    it 'validates wasapi_provider_account' do
      collection.wasapi_provider = nil
      collection.wasapi_account = nil
      expect(collection.valid?).to be(false)
    end

    it 'validates wasapi_collection_id' do
      collection.wasapi_collection_id = nil
      expect(collection.valid?).to be(false)
    end

    it 'validates default admin_policy' do
      expect(collection.admin_policy).to eq('druid:wr005wn5739')
    end

    it 'validates unique' do
      collection.wasapi_collection_id = '916'
      expect(collection.valid?).to be(false)
    end
  end

  context 'when validating druid' do
    let(:object_client) { instance_double(Dor::Services::Client::Object) }

    before do
      allow(Settings).to receive(:validate_collection_druid).and_return(true)
      allow(Dor::Services::Client).to receive(:object).and_return(object_client)
    end

    context 'when druid found and a collection' do
      let(:cocina_obj) { instance_double(Cocina::Models::Collection, collection?: true) }

      before do
        allow(object_client).to receive(:find).and_return(cocina_obj)
      end

      it 'is valid' do
        expect(collection.valid?).to be(true)
        expect(Dor::Services::Client).to have_received(:object).with('druid:dm081mp8068')
      end
    end

    context 'when druid found and not a collection' do
      let(:cocina_obj) { instance_double(Cocina::Models::DRO, collection?: false) }

      before do
        allow(object_client).to receive(:find).and_return(cocina_obj)
      end

      it 'is not valid' do
        expect(collection.valid?).to be(false)
        expect(collection.errors[:druid]).to eq(['not a collection'])
      end
    end

    context 'when not found' do
      before do
        allow(object_client).to receive(:find).and_raise(Dor::Services::Client::NotFoundResponse)
      end

      it 'is not valid' do
        expect(collection.valid?).to be(false)
        expect(collection.errors[:druid]).to eq(['does not exist'])
      end
    end
  end
end
