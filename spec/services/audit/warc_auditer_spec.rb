# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Audit::WarcAuditer do
  context 'with params' do
    let(:files) do
      described_class.audit(collection_druid: 'druid:hw105qf0103', wasapi_collection_id: '12189', wasapi_account: 'ua',
                            embargo_months: 3)
    end

    before do
      allow(Audit::WasapiWarcLister).to receive(:new).and_return(['FILE_1.warc.gz', 'FILE_2.warc.gz', 'FILE_3.warc.gz'])
      allow(Audit::SdrWarcLister).to receive(:new).and_return(['FILE_2.warc.gz', 'FILE_3.warc.gz', 'FILE_4.warc.gz'])
    end

    it 'returns missing files' do
      expect(files).to eq(['FILE_1.warc.gz'])
      expect(Audit::WasapiWarcLister).to have_received(:new).with(wasapi_collection_id: '12189', wasapi_provider: 'ait',
                                                                  wasapi_account: 'ua', embargo_months: 3)
      expect(Audit::SdrWarcLister).to have_received(:new).with(collection_druid: 'druid:hw105qf0103')
    end
  end

  context 'with a collection' do
    let(:files) do
      described_class.audit_collection(collection: collection)
    end

    let(:collection) do
      Collection.new(druid: 'druid:hw105qf0103', wasapi_collection_id: '12189', wasapi_account: 'ua',
                     wasapi_provider: 'ait', embargo_months: 3)
    end

    let(:auditer) { instance_double(described_class, audit: filenames) }

    let(:filenames) { ['FILE_1.warc.gz', 'FILE_2.warc.gz', 'FILE_3.warc.gz'] }

    before do
      allow(described_class).to receive(:new).and_return(auditer)
    end

    it 'invokes audit' do
      expect(files).to eq(filenames)
      expect(described_class).to have_received(:new).with(collection_druid: 'druid:hw105qf0103',
                                                          wasapi_collection_id: '12189',
                                                          wasapi_account: 'ua',
                                                          wasapi_provider: 'ait',
                                                          embargo_months: 3)
    end
  end
end
