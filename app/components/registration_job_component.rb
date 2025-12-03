# frozen_string_literal: true

# Draws a single table row that represents a Registration Job
class RegistrationJobComponent < ViewComponent::Base
  def initialize(registration_job:)
    super()
    @registration_job = registration_job
  end

  delegate :job_directory, :collection, :source_id, to: :registration_job

  private

  attr_reader :registration_job
end
