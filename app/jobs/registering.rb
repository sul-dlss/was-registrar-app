# frozen_string_literal: true

# Methods to assist jobs that register items.
module Registering
  def web_archives?(crawl_directory)
    WebArchiveGlob.web_archives(crawl_directory).any?
  end

  def start_workflow(druid, version)
    Dor::Services::Client.object(druid).workflow('wasCrawlPreassemblyWF').create(version:)
  end

  def success_status(obj, druid: nil)
    obj.update!(crawl_item_druid: druid, status: 'success', failure_reason: nil)
  end

  def running_status(obj)
    obj.update!(status: 'running', failure_reason: nil)
  end

  def failure_status(obj, exception)
    obj&.update!(failure_reason: exception.to_s, status: 'failure')
  end

  def register(request_params)
    Dor::Services::Client.objects.register(params: request_params)
  end
end
