# frozen_string_literal: true

# Validates that source Id is unique.
class UniqueSourceIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless Settings.validate_source_id
    # If there are already errors, the return.
    # This prevents an invalid source id from causing find from failing with an OpenAPI error.
    return if record.errors[attribute].present?

    Dor::Services::Client.objects.find(source_id: value)
    record.errors.add attribute, 'already exists'
  rescue Dor::Services::Client::NotFoundResponse
    # Does not exist, so no error.
  end
end
