# frozen_string_literal: true

# Controller for home page
class HomeController < ApplicationController
  def index
    @running_fetch_month_jobs, @running_registration_jobs = JobLister.list.partition { |obj| obj.is_a?(FetchMonth) }
  end
end
