# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Audit::WasapiWarcLister do
  let(:files) do
    described_class.new(wasapi_collection_id: '12189', wasapi_provider: 'ait', wasapi_account: 'ua',
                        embargo_months: 3).to_a
  end

  before do
    allow(Time.zone).to receive(:today).and_return(Time.zone.parse('2021-01-01'))
  end

  context 'when success' do
    let(:body) do
      <<~JSON
        {
          "count": 2,
          "next": null,
          "previous": null,
          "files": [{
            "filename": "ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190524001959215-00002-h3.warc.gz",
            "filetype": "warc",
            "checksums": {
              "md5": "611182afc6b5986c93b99c826bdbf2cf",
              "sha1": "74af193a5d6ec78f7431c0c8eab9bc3936495fda"
            },
            "account": 198,
            "size": 243582220,
            "collection": 12189,
            "crawl": 915353,
            "crawl-time": "2019-05-24T00:19:59.215000Z",
            "crawl-start": "2019-05-23T22:07:38.802000Z",
            "store-time": "2019-05-24T00:53:24.703627Z",
            "locations": ["https://warcs.archive-it.org/webdatafile/ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190524001959215-00002-h3.warc.gz", "https://archive.org/download/ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190524-00000/ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190524001959215-00002-h3.warc.gz"]
          }, {
            "filename": "ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523233238785-00001-h3.warc.gz",
            "filetype": "warc",
            "checksums": {
              "md5": "6599bd32ebc09b6036cd63dfc886d517",
              "sha1": "8938acbcfd24aab7333319469b018608bcebe76b"
            },
            "account": 198,
            "size": 1008717262,
            "collection": 12189,
            "crawl": 915353,
            "crawl-time": "2019-05-23T23:32:38.785000Z",
            "crawl-start": "2019-05-23T22:07:38.802000Z",
            "store-time": "2019-05-24T00:38:47.150419Z",
            "locations": ["https://warcs.archive-it.org/webdatafile/ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523233238785-00001-h3.warc.gz", "https://archive.org/download/ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523-00000/ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523233238785-00001-h3.warc.gz"]
          }],
          "includes-extra": false,
          "request-url": "https://archive-it.org/webdata?collection=12189"
        }
      JSON
    end

    before do
      stub_request(:get, 'https://archive-it.org/webdata?collection=12189&crawl-start-before=2020-10-01')
        .with(
          headers: {
            'Authorization' => 'Basic dXNlcjpwYXNz',
            'Content-Type' => 'application/json'
          }
        )
        .to_return(status: 200, body: body, headers: {})
    end

    it 'returns files' do
      expect(files).to eq(
        [
          'ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190524001959215-00002-h3.warc.gz',
          'ARCHIVEIT-12189-ONE_TIME-JOB915353-SEED2014399-20190523233238785-00001-h3.warc.gz'
        ]
      )
    end
  end

  context 'when an error' do
    before do
      stub_request(:get, 'https://archive-it.org/webdata?collection=12189&crawl-start-before=2020-10-01')
        .with(
          headers: {
            'Authorization' => 'Basic dXNlcjpwYXNz',
            'Content-Type' => 'application/json'
          }
        )
        .to_return(status: 403, body: '', headers: {})
    end

    it 'raises' do
      expect do
        files
      end.to raise_error('Getting https://archive-it.org/webdata?collection=12189&crawl-start-before=2020-10-01 ' \
                         'returned 403')
    end
  end
end
