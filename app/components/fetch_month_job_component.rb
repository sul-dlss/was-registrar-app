# frozen_string_literal: true

# Draws a single table row that represents a Fetch Job
class FetchMonthJobComponent < ViewComponent::Base
  with_collection_parameter :fetch_month

  def initialize(fetch_month:)
    super()
    @fetch_month = fetch_month
  end

  delegate :year, to: :fetch_month

  def month
    Date::MONTHNAMES[fetch_month.month]
  end

  def collection
    fetch_month.collection.title
  end

  private

  attr_reader :fetch_month
end
