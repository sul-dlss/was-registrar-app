# frozen_string_literal: true

# Draws a table of FetchMonths for a given collection
class FetchMonthsComponent < ViewComponent::Base
  def initialize(collection:)
    super()
    @collection = collection
  end

  private

  attr_reader :collection
end
