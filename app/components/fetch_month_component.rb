# frozen_string_literal: true

# Draws a single table row that represents a FetchMonth model
class FetchMonthComponent < ActionView::Component::Base
  def initialize(fetch_month:)
    @fetch_month = fetch_month
  end

  delegate :year, to: :fetch_month

  def month
    Date::MONTHNAMES[fetch_month.month]
  end

  def status
    ActiveSupport::SafeBuffer.new.tap do |out|
      out << fetch_month.status << create_status << argo_link << failure_status
    end
  end

  private

  def argo_link
    return unless crawl_item_druid

    path = format(Settings.argo_view_url, crawl_item_druid)
    link_to crawl_item_druid, path, target: '_new'
  end

  def create_status
    return unless fetch_month.status == 'success'

    crawl_item_druid ? ': Created ' : ': No WARCs fetched'
  end

  def failure_status
    return unless failure_reason

    ": #{failure_reason}"
  end

  delegate :crawl_item_druid, :failure_reason, to: :fetch_month

  attr_reader :fetch_month
end
