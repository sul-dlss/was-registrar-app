# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchJob do
  let(:collection) { create(:collection, admin_policy: 'druid:yf700yh0557', wasapi_collection_id: '915') }
  let(:fetch_month) { create(:fetch_month, collection: collection) }

  describe '#perform_now' do
    let(:stderr) { nil }
    context 'when the fetch is successful and there are no warcs' do
      before do
        expect(Open3).to receive(:capture3).and_return([nil, stderr, status])
        expect(FileUtils).to receive(:mkdir_p).with('tmp/jobs/AIT_915/2017_11')
        allow(Dir).to receive(:glob).with('tmp/jobs/AIT_915/2017_11/**/*.warc*').and_return([])
      end
      let(:status) { instance_double(Process::Status, success?: true) }

      it 'run successfully' do
        described_class.perform_now(fetch_month)
        expect(fetch_month.status).to eq 'success'
        expect(fetch_month.failure_reason).to be_nil
      end
    end

    context 'when the fetch is successful and there are warcs' do
      let('druid') { 'druid:bc123df4557' }
      let(:version_client) { instance_double(Dor::Services::Client::ObjectVersion, current: '5') }
      let(:object_client) { instance_double(Dor::Services::Client::Object, version: version_client) }
      let(:response_model) { instance_double(Cocina::Models::DRO, externalIdentifier: druid) }
      let(:objects_client) { instance_double(Dor::Services::Client::Objects, register: response_model) }
      let(:wf_client) { instance_double(Dor::Workflow::Client) }

      before do
        expect(Open3).to receive(:capture3).and_return([nil, stderr, status])
        expect(FileUtils).to receive(:mkdir_p).with('tmp/jobs/AIT_915/2017_11')
        allow(Dir).to receive(:glob).with('tmp/jobs/AIT_915/2017_11/**/*.warc*').and_return(['foo.warc'])
        allow(Dor::Services::Client).to receive(:objects).and_return(objects_client)
        allow(Dor::Services::Client).to receive(:object).and_return(object_client)
        allow(Dor::Workflow::Client).to receive(:new).and_return(wf_client)
        expect(wf_client).to receive(:create_workflow_by_name).with(druid, 'wasCrawlPreassemblyWF', version: 5)
      end

      let(:status) { instance_double(Process::Status, success?: true) }

      let(:expected) do
        Cocina::Models::RequestDRO.new({ type: 'http://cocina.sul.stanford.edu/models/webarchive-binary.jsonld',
                                         label: 'AIT_915/2017_11',
                                         version: 1,
                                         access: { access: 'dark' },
                                         administrative: { hasAdminPolicy: 'druid:yf700yh0557' },
                                         identification: { sourceId: 'sul:ait-915-2017_11' },
                                         structural: { isMemberOf: [fetch_month.collection.druid] } })
      end

      it 'run successfully' do
        described_class.perform_now(fetch_month)
        expect(fetch_month.status).to eq 'success'
        expect(fetch_month.failure_reason).to be_nil
        expect(objects_client).to have_received(:register).with(params: expected)
      end
    end

    context 'when the fetch is not successful' do
      let(:status) { instance_double(Process::Status, success?: false) }
      let(:stderr) { 'Ooops' }

      before do
        expect(Open3).to receive(:capture3).and_return([nil, stderr, status])
        expect(FileUtils).to receive(:mkdir_p).with('tmp/jobs/AIT_915/2017_11')
      end

      it 'raises an error successfully' do
        expect { described_class.perform_now(fetch_month) }.to raise_error 'Fetching WARCs failed: Ooops'
        expect(fetch_month.status).to eq 'failure'
        expect(fetch_month.failure_reason).to eq 'Fetching WARCs failed: Ooops'
      end
    end

    context 'when a non-fetch error occurs' do
      before do
        expect(FileUtils).to receive(:mkdir_p).with('tmp/jobs/AIT_915/2017_11').and_raise(Errno::ENOSPC)
      end

      it 'raises an error successfully' do
        expect { described_class.perform_now(fetch_month) }.to raise_error Errno::ENOSPC
        expect(fetch_month.status).to eq 'failure'
        expect(fetch_month.failure_reason).to eq 'No space left on device'
      end
    end
  end

  describe '#downloader_args' do
    let(:job) do
      described_class.new.tap { |job| job.instance_variable_set(:@fetch_month, fetch_month) }
    end
    it 'returns the correct args' do
      expect(job.downloader_args).to eq(['--crawlStartAfter',
                                         '2017-11-01',
                                         '--crawlStartBefore',
                                         '2017-12-01',
                                         '--baseurl',
                                         'https://archive-it.org/',
                                         '--authurl',
                                         'https://archive-it.org/login',
                                         '--username',
                                         'user',
                                         '--password',
                                         'pass',
                                         '--outputBaseDir',
                                         'tmp/jobs/AIT_915/2017_11/',
                                         '--collectionId',
                                         '915',
                                         '--resume'])
    end
  end
end
