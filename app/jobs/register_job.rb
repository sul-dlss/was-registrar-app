# frozen_string_literal: true

# Register and item and kick off accessioning workflow
class RegisterJob < ApplicationJob
  include Registering
  queue_as :default

  rescue_from(StandardError) do |exception|
    failure_status(registration_job, exception)
    raise exception
  end

  attr_reader :registration_job

  def perform(registration_job)
    @registration_job = registration_job
    running_status(registration_job)
    return success_status(registration_job) unless web_archives?(registration_job.crawl_directory)

    cocina_obj = register(request_params)
    start_workflow(cocina_obj.externalIdentifier, cocina_obj.version)
    success_status(registration_job, druid: cocina_obj.externalIdentifier)
  end

  def request_params
    RequestBuilder.build(title: registration_job.job_directory,
                         source_id: registration_job.source_id,
                         admin_policy: registration_job.admin_policy,
                         collection: registration_job.collection,
                         crawl_directory: registration_job.crawl_directory)
  end
end
