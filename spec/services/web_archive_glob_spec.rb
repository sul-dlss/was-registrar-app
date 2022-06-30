# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WebArchiveGlob do
  let(:filepath) { 'spec/fixtures/jobs/AIT_915/2017_11' }

  describe '#warcs' do
    it 'lists WARCs' do
      expect(described_class.warcs(filepath)).to eq ['spec/fixtures/jobs/AIT_915/2017_11/AIT-915-1.warc.gz',
                                                     'spec/fixtures/jobs/AIT_915/2017_11/patch/AIT-915-2.warc']
    end
  end

  describe '#waczs' do
    it 'lists WACZs' do
      expect(described_class.waczs(filepath)).to eq ['spec/fixtures/jobs/AIT_915/2017_11/AIT-915-3.wacz']
    end
  end

  describe '#web_archives' do
    it 'lists WARCs and WACZs' do
      expect(described_class.web_archives(filepath)).to eq ['spec/fixtures/jobs/AIT_915/2017_11/AIT-915-1.warc.gz',
                                                            'spec/fixtures/jobs/AIT_915/2017_11/patch/AIT-915-2.warc',
                                                            'spec/fixtures/jobs/AIT_915/2017_11/AIT-915-3.wacz']
    end
  end
end
