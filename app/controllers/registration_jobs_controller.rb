# frozen_string_literal: true

# Controller for one-time registration jobs
class RegistrationJobsController < ApplicationController
  def index
    @registration_jobs = RegistrationJob.order('created_at desc')
  end

  def new
    @registration_job = RegistrationJob.new
  end

  def create
    @registration_job = RegistrationJob.new(registration_job_params)

    if @registration_job.save
      RegisterJob.perform_later(@registration_job)
      flash[:notice] = 'Queueing one-time registration.'
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def registration_job_params
    params.expect(registration_job: %i[job_directory collection admin_policy source_id])
  end
end
