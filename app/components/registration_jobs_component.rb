# frozen_string_literal: true

# Draws a table of listing the RegistrationJobs that have current jobs
class RegistrationJobsComponent < ViewComponent::Base
  def initialize(registration_jobs:)
    super()
    @registration_jobs = registration_jobs
  end

  private

  attr_reader :registration_jobs
end
