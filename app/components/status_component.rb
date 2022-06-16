# frozen_string_literal: true

# Renders status for a model that has status, crawl_item_druid, and failure_reason
class StatusComponent < ViewComponent::Base
  def initialize(status_obj:)
    super
    @status_obj = status_obj
  end

  def status
    ActiveSupport::SafeBuffer.new.tap do |out|
      out << status_obj.status << create_status << argo_link << failure_status
    end
  end

  private

  attr_reader :status_obj

  delegate :crawl_item_druid, :failure_reason, to: :status_obj

  def argo_link
    return unless crawl_item_druid

    # Prefer `String#%` to `Kernel#format` now that `ActionView::Component`
    # responds to `#format` as of version 1.4.0
    path = Settings.argo_view_url % crawl_item_druid
    link_to crawl_item_druid, path, target: '_new'
  end

  def create_status
    return unless status_obj.status == 'success'

    crawl_item_druid ? ': Created ' : ': No WARCs'
  end

  def failure_status
    return unless failure_reason

    ": #{failure_reason}"
  end
end
