# frozen_string_literal: true

# Draws a table of FetchMonths for a given collection
class FetchMonthsComponent < ViewComponent::Base
  def initialize(collection:)
    @collection = collection
  end

  private

  attr_reader :collection
end
