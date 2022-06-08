# frozen_string_literal: true

# Draws a single table row that represents a FetchMonth model
class FetchMonthComponent < ViewComponent::Base
  def initialize(fetch_month:)
    super
    @fetch_month = fetch_month
  end

  delegate :year, to: :fetch_month

  attr_reader :fetch_month

  def month
    Date::MONTHNAMES[fetch_month.month]
  end
end
