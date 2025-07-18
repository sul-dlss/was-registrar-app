# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FetchJob do
  let(:output_dir) { 'spec/fixtures/jobs/AIT_915/2017_11' }
  let(:collection) { create(:ar_collection, admin_policy: 'druid:yf700yh0557', wasapi_collection_id: '915') }
  let(:fetch_month) { create(:fetch_month, collection:, year: 2017) }

  describe '#perform_now' do
    context 'when the fetch is successful and there are no warcs' do
      before do
        allow(WasapiClient).to receive(:new).and_return(instance_double(WasapiClient, fetch_warcs: nil))
        allow(FileUtils).to receive(:mkdir_p).with(output_dir).and_call_original
        allow(WebArchiveGlob).to receive(:web_archives).with(output_dir).and_return([])
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
        allow(WasapiClient).to receive(:new).and_return(instance_double(WasapiClient, fetch_warcs: nil))
        allow(WebArchiveGlob).to receive(:web_archives)
          .with(output_dir).and_return(['foo.warc'])
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
      let(:wasapi_client) { instance_double(WasapiClient) }

      before do
        allow(WasapiClient).to receive(:new).and_return(wasapi_client)
        allow(wasapi_client).to receive(:fetch_warcs).and_raise(RuntimeError, 'Failed to fetch a valid file')
      end

      it 'raises an error' do
        expect do
          described_class.perform_now(fetch_month)
        end.to raise_error RuntimeError, 'Fetching WARCs failed: Failed to fetch a valid file'
        expect(fetch_month.status).to eq 'failure'
        expect(fetch_month.failure_reason).to eq 'Fetching WARCs failed: Failed to fetch a valid file'
      end
    end

    context 'when a non-fetch error occurs' do
      let(:wasapi_client) { instance_double(WasapiClient) }

      before do
        allow(WasapiClient).to receive(:new).and_return(wasapi_client)
        allow(wasapi_client).to receive(:fetch_warcs).and_raise(Errno::ENOSPC)
      end

      it 'raises an error' do
        expect { described_class.perform_now(fetch_month) }.to raise_error StandardError
        expect(fetch_month.status).to eq 'failure'
        expect(fetch_month.failure_reason).to eq 'Fetching WARCs failed: No space left on device'
      end
    end
  end
end
