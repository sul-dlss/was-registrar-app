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

      before do
        allow(Open3).to receive(:capture3).and_return([nil, nil, status])
        allow(RegistrationJob).to receive(:create!).and_return(registration_job)
        allow(RegisterJob).to receive(:perform_later)
      end

      it 'fetches and registers' do
        expect(job_directory).to eq('AIT_12189/patch-missing-2021_01_01')
        expect(FileUtils).to have_received(:mkdir_p).with('spec/fixtures/jobs/AIT_12189/patch-missing-2021_01_01')
        expect(Open3).to have_received(:capture3).with('wasapi-downloader/bin/wasapi-downloader', '--filename',
                                                       'AIT-12189-1.warc.gz', '--baseurl', 'https://archive-it.org/',
                                                       '--authurl', 'https://archive-it.org/login',
                                                       '--username', 'user',
                                                       '--password', 'pass',
                                                       '--outputBaseDir',
                                                       'spec/fixtures/jobs/AIT_12189/patch-missing-2021_01_01/',
                                                       '--resume')
        expect(RegistrationJob).to have_received(:create!).with(admin_policy: 'druid:wr005wn5739',
                                                                collection: 'druid:gq319xk9269',
                                                                job_directory: 'AIT_12189/patch-missing-2021_01_01',
                                                                source_id: 'sul:AIT-12189-patch-missing-2021_01_01')
        expect(RegisterJob).to have_received(:perform_later).with(registration_job)
      end
    end

    context 'when fetch fails' do
      let(:status) { instance_double(Process::Status, success?: false) }

      before do
        allow(Open3).to receive(:capture3).and_return([nil, 'Not found', status])
      end

      it 'raises an error' do
        expect { job_directory }.to raise_error(RuntimeError, 'Fetching WARCs failed: Not found')
      end
    end
  end

  context 'with a collection' do
    let(:job_directory) do
      described_class.remediate_collection(collection: collection, filenames: filenames)
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
                                                          filenames: filenames,
                                                          admin_policy_druid: 'druid:wr005wn5739',
                                                          source_id: nil)
    end
  end
end
