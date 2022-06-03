# frozen_string_literal: true

# Validates that collection exists.
class CollectionDruidValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless Settings.validate_collection_druid
    # If there are already errors, the return.
    # This prevents an invalid druid from causing find from failing with an OpenAPI error.
    return if record.errors[attribute].present?

    cocina_obj = Dor::Services::Client.object(value).find
    record.errors.add attribute, 'not a collection' unless cocina_obj.collection?
  rescue Dor::Services::Client::NotFoundResponse
    record.errors.add attribute, 'does not exist'
  end
end
