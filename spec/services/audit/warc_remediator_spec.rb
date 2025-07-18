# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Audit::WarcRemediator do
  context 'with params' do
    let(:job_directory) do
      described_class.remediate(collection_druid: 'druid:gq319xk9269', wasapi_collection_id: '12189',
                                wasapi_account: 'ua', filenames: ['AIT-12189-1.warc.gz'])
    end

    before do
      allow(Time.zone).to receive(:today).and_return(Time.zone.parse('2021-01-01'))
      allow(FileUtils).to receive(:mkdir_p)
    end

    context 'when fetch succeeds' do
      let(:status) { instance_double(Process::Status, success?: true) }
      let(:registration_job) { instance_double(RegistrationJob) }
      let(:wasapi_client) do
        instance_double(WasapiClient,
                        fetch_file: 'spec/fixtures/jobs/AIT_12189/patch-missing-2021_01_01AIT-12189-1.warc.gz')
      end

      before do
        allow(RegistrationJob).to receive(:create!).and_return(registration_job)
        allow(RegisterJob).to receive(:perform_later)
        allow(WasapiClient).to receive(:new).and_return(wasapi_client)
      end

      it 'fetches and registers' do
        expect(job_directory).to eq('AIT_12189/patch-missing-2021_01_01')
        expect(FileUtils).to have_received(:mkdir_p).with('spec/fixtures/jobs/AIT_12189/patch-missing-2021_01_01')
        expect(WasapiClient).to have_received(:new).with(username: 'user', password: 'pass')
        expect(wasapi_client).to have_received(:fetch_file)
          .with(file: 'AIT-12189-1.warc.gz', output_dir: 'spec/fixtures/jobs/AIT_12189/patch-missing-2021_01_01')
        expect(RegistrationJob).to have_received(:create!).with(admin_policy: 'druid:wr005wn5739',
                                                                collection: 'druid:gq319xk9269',
                                                                job_directory: 'AIT_12189/patch-missing-2021_01_01',
                                                                source_id: 'sul:AIT-12189-patch-missing-2021_01_01')
        expect(RegisterJob).to have_received(:perform_later).with(registration_job)
      end
    end

    context 'when fetch fails' do
      let(:status) { instance_double(Process::Status, success?: false) }
      let(:wasapi_client) { instance_double(WasapiClient) }

      before do
        allow(WasapiClient).to receive(:new).and_return(wasapi_client)
        allow(wasapi_client).to receive(:fetch_file)
          .and_raise(RuntimeError, 'Failed to download file from AIT-12189-1.warc.gz: 404')
      end

      it 'raises an error' do
        expect do
          described_class.remediate(collection_druid: 'druid:gq319xk9269', wasapi_collection_id: '12189',
                                    wasapi_account: 'ua', filenames: ['AIT-12189-1.warc.gz'])
        end.to raise_error(RuntimeError, 'Fetching WARC failed: Failed to download file from AIT-12189-1.warc.gz: 404')
        expect(FileUtils).to have_received(:mkdir_p).with('spec/fixtures/jobs/AIT_12189/patch-missing-2021_01_01')
        expect(WasapiClient).to have_received(:new).with(username: 'user', password: 'pass')
        expect(wasapi_client).to have_received(:fetch_file)
          .with(file: 'AIT-12189-1.warc.gz', output_dir: 'spec/fixtures/jobs/AIT_12189/patch-missing-2021_01_01')
      end
    end
  end

  context 'with a collection' do
    let(:job_directory) do
      described_class.remediate_collection(collection:, filenames:)
    end

    let(:collection) do
      Collection.new(druid: 'druid:hw105qf0103', wasapi_collection_id: '12189', wasapi_account: 'ua',
                     wasapi_provider: 'ait', embargo_months: 3)
    end

    let(:remediator) { instance_double(described_class, remediate: 'AIT_12189/patch-missing-2021_01_01') }

    let(:filenames) { ['FILE_1.warc.gz', 'FILE_2.warc.gz', 'FILE_3.warc.gz'] }

    before do
      allow(described_class).to receive(:new).and_return(remediator)
    end

    it 'invokes audit' do
      expect(job_directory).to eq('AIT_12189/patch-missing-2021_01_01')
      expect(described_class).to have_received(:new).with(collection_druid: 'druid:hw105qf0103',
                                                          wasapi_collection_id: '12189',
                                                          wasapi_account: 'ua',
                                                          wasapi_provider: 'ait',
                                                          filenames:,
                                                          admin_policy_druid: 'druid:wr005wn5739',
                                                          source_id: nil)
    end
  end
end
