# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchJob do
  let(:collection) { create(:collection, admin_policy: 'druid:yf700yh0557') }
  let(:fetch_month) { create(:fetch_month, collection: collection) }

  describe '#perform_now' do
    before do
      expect(Open3).to receive(:capture3).and_return([nil, stderr, status])
      expect(FileUtils).to receive(:mkdir_p).with('tmp/jobs/AIT_915/2017_11')
    end

    let(:stderr) { nil }
    context 'when the fetch is successful and there are no warcs' do
      before do
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
      let('druid') { 'druid:abc123' }
      let(:objects_client) { instance_double(Dor::Services::Client::Objects, register: { pid: druid }) }
      let(:wf_client) { instance_double(Dor::Workflow::Client) }

      before do
        allow(Dir).to receive(:glob).with('tmp/jobs/AIT_915/2017_11/**/*.warc*').and_return(['foo.warc'])
        allow(Dor::Services::Client).to receive(:objects).and_return(objects_client)
        allow(Dor::Workflow::Client).to receive(:new).and_return(wf_client)
        expect(wf_client).to receive(:create_workflow_by_name).with(druid, 'wasCrawlPreassemblyWF')
      end

      let(:status) { instance_double(Process::Status, success?: true) }

      it 'run successfully' do
        described_class.perform_now(fetch_month)
        expect(fetch_month.status).to eq 'success'
        expect(fetch_month.failure_reason).to be_nil
        expect(objects_client).to have_received(:register).with(params: { admin_policy: 'druid:yf700yh0557',
                                                                          collection: fetch_month.collection.druid,
                                                                          label: 'AIT_915/2017_11',
                                                                          object_type: 'item',
                                                                          rights: 'dark',
                                                                          source_id: 'sul:ait-915-2017_11' })
      end
    end

    context 'when the fetch is not successful' do
      let(:status) { instance_double(Process::Status, success?: false) }
      let(:stderr) { 'Ooops' }

      it 'raises an error successfully' do
        expect { described_class.perform_now(fetch_month) }.to raise_error 'Fetching WARCs failed: Ooops'
        expect(fetch_month.status).to eq 'failure'
        expect(fetch_month.failure_reason).to eq 'Fetching WARCs failed: Ooops'
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
