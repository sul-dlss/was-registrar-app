# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RequestBuilder do
  let(:request) { described_class.build(fetch_month: fetch_month) }
  let(:admin_policy_druid) { 'druid:yf700yh0557' }
  let(:collection) { create(:ar_collection, admin_policy: admin_policy_druid, wasapi_collection_id: '915') }
  let(:fetch_month) { create(:fetch_month, collection: collection, year: 2017, month: 11) }
  let(:object_client) { instance_double(Dor::Services::Client::Object, find: admin_policy) }
  let(:admin_policy) do
    build(:admin_policy, id: admin_policy_druid).new(
      administrative: {
        hasAdminPolicy: 'druid:hv992ry2431',
        hasAgreement: 'druid:hp308wm0436',
        accessTemplate: {
          view: view,
          download: 'none'
        }
      }
    )
  end

  let(:expected) do
    Cocina::Models::RequestDRO.new({ type: Cocina::Models::ObjectType.webarchive_binary,
                                     label: 'AIT_915/2017_11',
                                     version: 1,
                                     description: { title: [{ value: 'AIT_915/2017_11' }] },
                                     access: { view: 'citation-only', download: 'none' },
                                     administrative: { hasAdminPolicy: 'druid:yf700yh0557' },
                                     identification: { sourceId: 'sul:ait-915-2017_11' },
                                     structural: {
                                       isMemberOf: [fetch_month.collection.druid],
                                       contains: [
                                         {
                                           type: Cocina::Models::FileSetType.file,
                                           label: 'AIT-915-1.warc.gz',
                                           version: 1,
                                           structural:
                                           {
                                             contains:
                                             [
                                               {
                                                 type: Cocina::Models::ObjectType.file,
                                                 label: 'AIT-915-1.warc.gz',
                                                 filename: 'AIT-915-1.warc.gz',
                                                 size: 9,
                                                 version: 1,
                                                 hasMimeType: 'application/warc',
                                                 hasMessageDigests:
                                                     [
                                                       { type: 'md5', digest: '32f38a4fbad4755474bc375b8a8437ea' },
                                                       { type: 'sha1',
                                                         digest: '649b12da4651444f9b6e922472d1dc257ae96f50' }
                                                     ],
                                                 access:
                                                     { view: 'dark', download: 'none',
                                                       controlledDigitalLending: false },
                                                 administrative:
                                                     { publish: false, sdrPreserve: true, shelve: shelve }
                                               }
                                             ]
                                           }
                                         },
                                         {
                                           type: Cocina::Models::FileSetType.file,
                                           label: 'AIT-915-2.warc.gz',
                                           version: 1,
                                           structural:
                                           {
                                             contains:
                                             [
                                               {
                                                 type: Cocina::Models::ObjectType.file,
                                                 label: 'AIT-915-2.warc.gz',
                                                 filename: 'AIT-915-2.warc.gz',
                                                 size: 9,
                                                 version: 1,
                                                 hasMimeType: 'application/warc',
                                                 hasMessageDigests:
                                                   [
                                                     { type: 'md5', digest: '1308213ee3c749d63af30e6dbdab010d' },
                                                     { type: 'sha1',
                                                       digest: 'a3f4648b8175f9148414bdca450c72ddc9f7ff9b' }
                                                   ],
                                                 access:
                                                   { view: 'dark', download: 'none',
                                                     controlledDigitalLending: false },
                                                 administrative:
                                                   { publish: false, sdrPreserve: true, shelve: shelve }
                                               }
                                             ]
                                           }
                                         }
                                       ]
                                     } })
  end

  before do
    allow(Settings).to receive(:crawl_directory).and_return('spec/fixtures/jobs')
    allow(Dor::Services::Client).to receive(:object).with(admin_policy_druid).and_return(object_client)
  end

  describe 'build' do
    context 'when world' do
      let(:view) { 'world' }
      let(:shelve) { true }

      it 'shelves' do
        expect(request).to eq(expected)
      end
    end

    context 'when dark' do
      let(:view) { 'dark' }
      let(:shelve) { false }

      it 'does not shelve' do
        expect(request).to eq(expected)
      end
    end
  end
end
