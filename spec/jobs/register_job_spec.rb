# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegisterJob do
  let(:registration_job) { create(:registration_job, job_directory: 'AIT_915/2017_11') }

  describe '#perform_now' do
    context 'when there are no warcs' do
      before do
        allow(Dir).to receive(:glob).with('spec/fixtures/jobs/AIT_915/2017_11/**/*.warc*').and_return([])
      end

      it 'runs successfully' do
        described_class.perform_now(registration_job)
        expect(registration_job.status).to eq 'success'
        expect(registration_job.failure_reason).to be_nil
        expect(registration_job.crawl_item_druid).to be_nil
      end
    end

    context 'when there are warcs' do
      let(:druid) { 'druid:bc123df4557' }
      let(:request_dro) { instance_double(Cocina::Models::RequestDRO) }
      let(:response_model) { instance_double(Cocina::Models::DRO, externalIdentifier: druid, version: 1) }
      let(:objects_client) { instance_double(Dor::Services::Client::Objects, register: response_model) }
      let(:wf_client) { instance_double(Dor::Workflow::Client) }

      before do
        allow(Dor::Services::Client).to receive(:objects).and_return(objects_client)
        allow(Dor::Workflow::Client).to receive(:new).and_return(wf_client)
        allow(wf_client).to receive(:create_workflow_by_name)
        allow(RequestBuilder).to receive(:build).and_return(request_dro)
      end

      it 'runs successfully' do
        described_class.perform_now(registration_job)
        expect(wf_client).to have_received(:create_workflow_by_name).with(druid, 'wasCrawlPreassemblyWF', version: 1)
        expect(registration_job.status).to eq 'success'
        expect(registration_job.failure_reason).to be_nil
        expect(registration_job.crawl_item_druid).to eq druid
        expect(RequestBuilder).to have_received(:build).with(title: registration_job.job_directory,
                                                             source_id: registration_job.source_id,
                                                             admin_policy: registration_job.admin_policy,
                                                             collection: registration_job.collection,
                                                             crawl_directory: registration_job.crawl_directory)
        expect(objects_client).to have_received(:register).with(params: request_dro)
      end
    end

    context 'when an error' do
      let(:druid) { 'druid:bc123df4557' }
      let(:request_dro) { instance_double(Cocina::Models::RequestDRO) }
      let(:objects_client) { instance_double(Dor::Services::Client::Objects) }

      before do
        allow(Dor::Services::Client).to receive(:objects).and_return(objects_client)
        allow(RequestBuilder).to receive(:build).and_return(request_dro)
        allow(objects_client).to receive(:register)
          .and_raise(Dor::Services::Client::UnexpectedResponse.new(response: '',
                                                                   errors: [{ 'title' => 'Oops!' }]))
      end

      it 'runs unsuccessfully' do
        expect do
          described_class.perform_now(registration_job)
        end.to raise_error(Dor::Services::Client::UnexpectedResponse)
        expect(registration_job.status).to eq 'failure'
        expect(registration_job.failure_reason).to eq('Oops! ()')
        expect(objects_client).to have_received(:register).with(params: request_dro)
      end
    end
  end
end
