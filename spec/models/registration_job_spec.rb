# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationJob, type: :model do
  let(:registration_job) { build(:registration_job, job_directory: 'AIT_915/2017_11') }

  describe '#crawl_directory' do
    it 'returns the correct crawl directory' do
      expect(registration_job.crawl_directory).to eq('spec/fixtures/jobs/AIT_915/2017_11')
    end
  end

  describe '#valid?' do
    before do
      allow(Settings).to receive(:validate_job_directory).and_return(true)
    end

    context 'with a valid registration job' do
      it 'validates' do
        expect(registration_job.valid?).to be(true)
      end
    end

    context 'with an invalid registration job' do
      it 'validates job_directory' do
        registration_job.job_directory = nil
        expect(registration_job.valid?).to be(false)
      end

      it 'validates job_directory when missing and status is waiting' do
        registration_job.job_directory = 'foo'
        expect(registration_job.valid?).to be(false)
      end

      it 'validates job_directory when missing and status is not waiting' do
        registration_job.status = 'running'
        registration_job.job_directory = 'foo'
        expect(registration_job.valid?).to be(true)
      end

      it 'validates collection druid must begin with druid' do
        registration_job.collection = 'abc123'
        expect(registration_job.valid?).to be(false)
      end

      it 'validates source_id' do
        registration_job.source_id = nil
        expect(registration_job.valid?).to be(false)
      end

      it 'validates source_id must have correct structure' do
        registration_job.source_id = 'foo'
        expect(registration_job.valid?).to be(false)
      end
    end

    context 'when validating source Id' do
      let(:objects_client) { instance_double(Dor::Services::Client::Objects) }

      before do
        allow(Settings).to receive(:validate_source_id).and_return(true)
        allow(Dor::Services::Client).to receive(:objects).and_return(objects_client)
      end

      context 'when found and status is waiting' do
        before do
          allow(objects_client).to receive(:find).and_return(instance_double(Cocina::Models::DRO))
        end

        it 'is not valid' do
          expect(registration_job.valid?).to be(false)
          expect(objects_client).to have_received(:find).with(source_id: registration_job.source_id)
        end
      end

      context 'when status is not waiting' do
        it 'does not validate' do
          registration_job.status = 'running'
          expect(registration_job.valid?).to be(true)
        end
      end

      context 'when not found' do
        before do
          allow(objects_client).to receive(:find).and_raise(Dor::Services::Client::NotFoundResponse)
        end

        it 'is valid' do
          expect(registration_job.valid?).to be(true)
        end
      end
    end

    context 'when validating collection druid' do
      let(:object_client) { instance_double(Dor::Services::Client::Object) }

      before do
        allow(Settings).to receive(:validate_collection_druid).and_return(true)
        allow(Dor::Services::Client).to receive(:object).and_return(object_client)
      end

      context 'when druid found and a collection' do
        let(:cocina_obj) { instance_double(Cocina::Models::Collection, collection?: true) }

        before do
          allow(object_client).to receive(:find).and_return(cocina_obj)
        end

        it 'is not valid' do
          expect(registration_job.valid?).to be(true)
          expect(Dor::Services::Client).to have_received(:object).with('druid:bf172jb9970')
        end
      end

      context 'when not found' do
        before do
          allow(object_client).to receive(:find).and_raise(Dor::Services::Client::NotFoundResponse)
        end

        it 'is valid' do
          expect(registration_job.valid?).to be(false)
          expect(registration_job.errors[:collection]).to eq(['does not exist'])
        end
      end

      context 'when status is not waiting' do
        it 'does not validate' do
          registration_job.status = 'running'
          expect(registration_job.valid?).to be(true)
        end
      end
    end
  end
end
