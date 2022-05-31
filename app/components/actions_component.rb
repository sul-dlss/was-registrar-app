# frozen_string_literal: true

# Actions for a FetchMonth.
class ActionsComponent < ViewComponent::Base
  def initialize(collection:)
    super
    @collection = collection
  end

  def retry?
    FetchJobRetrier.retry?(collection: @collection)
  end
end
