# frozen_string_literal: true

# Validates that a job directory exists.
class JobDirectoryValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless Settings.validate_job_directory

    # If there are already errors, then return.
    return if record.errors[attribute].present?

    record.errors.add attribute, 'directory not found' unless exists?(value)
  end

  def exists?(job_directory)
    Dir.exist?(File.join(Settings.crawl_directory, job_directory))
  end
end
