# frozen_string_literal: true

# Fetch job creator service is invoked for a collection.
#
# If there are no existing fetch_months for the collection:
#
#     Create a fetch_month for every month between the first_fetch_month and now - embargo.
#     Initiate a fetch job for each new month.
#
# If there are existing fetch_months for the collection:
#
#     Create a fetch_month for every month between the last fetch_month and now - embargo.
#     Initiate a fetch job for each new month.
class FetchJobCreator
  def self.run(collection:)
    new(collection: collection).create
  end

  def initialize(collection:)
    @collection = collection
  end

  def create
    if collection.fetch_months.any?
      # Create a fetch_month for every month between the last fetch_month and now - embargo.
      last_month = collection.fetch_months.order(:year, :month).last
      create_for_months(last_month.to_date + 1.month)
    else
      # Create a fetch_month for every month between the fetch_start_month and now - embargo.
      create_for_months(collection.fetch_start_month)
    end
  end

  private

  attr_reader :collection

  def create_for_months(starting)
    date = starting
    while date < stop_month
      create_month(date)
      date += 1.month
    end
  end

  def create_month(date)
    month = collection.fetch_months.create!(year: date.year, month: date.month, status: 'waiting')
    FetchJob.perform_later(month)
  end

  def stop_month
    # Subtract an extra month to account for this month (which is part of a month),
    # since only dealing with whole months.
    @stop_month ||= Date.today - collection.embargo_months.months - 1.month
  end
end
