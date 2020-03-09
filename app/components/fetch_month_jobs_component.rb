# frozen_string_literal: true

# Draws a table of listing the FetchMonths that have current jobs
class FetchMonthJobsComponent < ViewComponent::Base
  def initialize(fetch_months:)
    @fetch_months = fetch_months
  end

  private

  attr_reader :fetch_months
end
