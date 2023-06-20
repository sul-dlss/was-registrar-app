# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'List registration jobs' do
  before do
    create(:registration_job, job_directory: 'crawl1')
    create(:registration_job, job_directory: 'crawl2')
  end

  it 'shows the information' do
    get '/registration_jobs'
    expect(response.body).to include 'Job directory'
    expect(response.body).to include 'crawl1'
    expect(response.body).to include 'crawl2'
    expect(response.body).to include 'Create a one-time registration'
  end
end
