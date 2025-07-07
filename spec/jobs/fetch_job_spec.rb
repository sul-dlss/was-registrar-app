# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchJob do
  let(:collection) { create(:ar_collection, admin_policy: 'druid:yf700yh0557', wasapi_collection_id: '915') }
  let(:fetch_month) { create(:fetch_month, collection:, year: 2017) }

  describe '#perform_now' do
    let(:stderr) { nil }

    context 'when the fetch is successful and there are no warcs' do
      before do
        allow(Open3).to receive(:capture3).and_return([nil, stderr, status])
        allow(FileUtils).to receive(:mkdir_p).with('spec/fixtures/jobs/AIT_915/2017_11').and_call_original
        allow(WebArchiveGlob).to receive(:web_archives).with('spec/fixtures/jobs/AIT_915/2017_11').and_return([])
      end

      let(:status) { instance_double(Process::Status, success?: true) }

      it 'runs successfully' do
        described_class.perform_now(fetch_month)
        expect(fetch_month.status).to eq 'success'
        expect(fetch_month.failure_reason).to be_nil
      end
    end

    context 'when the fetch is successful and there are warcs' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:druid) { 'druid:bc123df4557' }
      let(:status) { instance_double(Process::Status, success?: true) }
      let(:request_dro) { instance_double(Cocina::Models::RequestDRO) }
      let(:response_model) { instance_double(Cocina::Models::DRO, externalIdentifier: druid, version: 1) }
      let(:objects_client) { instance_double(Dor::Services::Client::Objects, register: response_model) }
      let(:wf_client) { instance_double(Dor::Services::Client::Object) }
      let(:workflow) { instance_double(Dor::Services::Client::ObjectWorkflow) }

      before do
        allow(Open3).to receive(:capture3).and_return([nil, stderr, status])
        allow(FileUtils).to receive(:mkdir_p).with('spec/fixtures/jobs/AIT_915/2017_11').and_call_original
        allow(WebArchiveGlob).to receive(:web_archives)
          .with('spec/fixtures/jobs/AIT_915/2017_11').and_return(['foo.warc'])
        allow(Dor::Services::Client).to receive(:objects).and_return(objects_client)
        allow(Dor::Services::Client).to receive(:object).with(druid).and_return(wf_client)
        allow(wf_client).to receive(:workflow).with('wasCrawlPreassemblyWF').and_return(workflow)
        allow(workflow).to receive(:create).with(version: 1)
        allow(RequestBuilder).to receive(:build).and_return(request_dro)
      end

      it 'runs successfully' do
        described_class.perform_now(fetch_month)
        expect(workflow).to have_received(:create).with(version: 1)
        expect(fetch_month.status).to eq 'success'
        expect(fetch_month.failure_reason).to be_nil
        expect(RequestBuilder).to have_received(:build).with(title: fetch_month.job_directory,
                                                             source_id: fetch_month.source_id,
                                                             admin_policy: fetch_month.collection.admin_policy,
                                                             collection: fetch_month.collection.druid,
                                                             crawl_directory: fetch_month.crawl_directory)
        expect(objects_client).to have_received(:register).with(params: request_dro)
      end
    end

    context 'when the fetch is not successful' do
      let(:status) { instance_double(Process::Status, success?: false) }
      let(:stderr) { 'Ooops' }

      before do
        allow(Open3).to receive(:capture3).and_return([nil, stderr, status])
        allow(FileUtils).to receive(:mkdir_p).with('spec/fixtures/jobs/AIT_915/2017_11').and_call_original
      end

      it 'raises an error' do
        expect { described_class.perform_now(fetch_month) }.to raise_error 'Fetching WARCs failed: Ooops'
        expect(fetch_month.status).to eq 'failure'
        expect(fetch_month.failure_reason).to eq 'Fetching WARCs failed: Ooops'
      end
    end

    context 'when a non-fetch error occurs' do
      before do
        allow(FileUtils).to receive(:mkdir_p).with('spec/fixtures/jobs/AIT_915/2017_11').and_raise(Errno::ENOSPC)
      end

      it 'raises an error' do
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
                                         'spec/fixtures/jobs/AIT_915/2017_11/',
                                         '--collectionId',
                                         '915',
                                         '--resume'])
    end
  end
end
