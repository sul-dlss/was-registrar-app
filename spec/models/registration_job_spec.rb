# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationJob, type: :model do
  let(:registration_job) { create(:registration_job, job_directory: 'AIT_915/2017_11') }

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

      it 'validates job_directory when missing' do
        registration_job.job_directory = 'foo'
        expect(registration_job.valid?).to be(false)
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
  end
end
