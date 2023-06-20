# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable RSpec/IndexedLet
RSpec.describe Audit::SdrWarcLister do
  let(:files) { described_class.new(collection_druid: 'druid:hw105qf0103').to_a }

  let(:object_client) { instance_double(Dor::Services::Client::Object, members:) }
  let(:object_client1) { instance_double(Dor::Services::Client::Object, find: cocina1) }
  let(:object_client2) { instance_double(Dor::Services::Client::Object, find: cocina2) }
  let(:members) do
    [
      Dor::Services::Client::Members::Member.new(externalIdentifier: 'druid:cv062jz2211', type: 'item'),
      Dor::Services::Client::Members::Member.new(externalIdentifier: 'druid:kx571tc4076', type: 'item')
    ]
  end
  let(:cocina1) do
    build(:dro, id: 'druid:cv062jz2211', type: Cocina::Models::ObjectType.webarchive_binary).new(
      structural: {
        contains: [{
          type: 'https://cocina.sul.stanford.edu/models/resources/file',
          externalIdentifier: 'https://cocina.sul.stanford.edu/fileSet/kx571tc4076-kx571tc4076_1',
          label: '',
          version: 1,
          structural: {
            contains: [{
              type: 'https://cocina.sul.stanford.edu/models/file',
              externalIdentifier: 'https://cocina.sul.stanford.edu/file/kx571tc4076-kx571tc4076_1/ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523220742664-00000-h3.warc.gz',
              label: 'ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523220742664-00000-h3.warc.gz',
              filename: 'ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523220742664-00000-h3.warc.gz',
              size: 1_002_084_829,
              version: 1,
              hasMimeType: 'application/warc',
              hasMessageDigests: [{
                type: 'sha1',
                digest: '7baed835ed1f3c6c08e831697baab9412b91c152'
              }, {
                type: 'md5',
                digest: 'e3ef04d8a94e755fe350f7de24a854f1'
              }],
              access: {
                view: 'dark',
                download: 'none',
                controlledDigitalLending: false
              },
              administrative: {
                publish: false,
                sdrPreserve: true,
                shelve: false
              }
            }]
          }
        }, {
          type: 'https://cocina.sul.stanford.edu/models/resources/file',
          externalIdentifier: 'https://cocina.sul.stanford.edu/fileSet/kx571tc4076-kx571tc4076_2',
          label: '',
          version: 1,
          structural: {
            contains: [{
              type: 'https://cocina.sul.stanford.edu/models/file',
              externalIdentifier: 'https://cocina.sul.stanford.edu/file/kx571tc4076-kx571tc4076_2/ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523233238785-00001-h3.warc.gz',
              label: 'ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523233238785-00001-h3.warc.gz',
              filename: 'ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523233238785-00001-h3.warc.gz',
              size: 1_008_717_262,
              version: 1,
              hasMimeType: 'application/warc',
              hasMessageDigests: [{
                type: 'sha1',
                digest: '8938acbcfd24aab7333319469b018608bcebe76b'
              }, {
                type: 'md5',
                digest: '6599bd32ebc09b6036cd63dfc886d517'
              }],
              access: {
                view: 'dark',
                download: 'none',
                controlledDigitalLending: false
              },
              administrative: {
                publish: false,
                sdrPreserve: true,
                shelve: false
              }
            }]
          }
        }],
        hasMemberOrders: [],
        isMemberOf: ['druid:hw105qf0103']
      }
    )
  end
  let(:cocina2) { build(:dro, id: 'druid:kx571tc4076', type: Cocina::Models::ObjectType.webarchive_seed) }

  before do
    allow(Dor::Services::Client).to receive(:object).and_return(object_client, object_client1, object_client2)
    allow(cocina2).to receive(:structural)
  end

  it 'lists files' do
    expect(files).to eq([
                          'ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523220742664-00000-h3.warc.gz',
                          'ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523233238785-00001-h3.warc.gz'
                        ])
    expect(Dor::Services::Client).to have_received(:object)
      .with('druid:hw105qf0103').with('druid:cv062jz2211').with('druid:kx571tc4076')
    expect(cocina2).not_to have_received(:structural)
  end
end
# rubocop:enable RSpec/IndexedLet
