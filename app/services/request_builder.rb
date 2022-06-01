# frozen_string_literal: true

# Builds a RequestDRO for registering a crawl.
class RequestBuilder
  def self.build(fetch_month:)
    new(fetch_month: fetch_month).build
  end

  def initialize(fetch_month:)
    @fetch_month = fetch_month
  end

  def build
    Cocina::Models::RequestDRO.new(props)
  end

  private

  attr_reader :fetch_month

  def props
    {
      type: Cocina::Models::ObjectType.webarchive_binary,
      label: fetch_month.job_directory,
      version: 1,
      description: { title: [{ value: fetch_month.job_directory }] },
      access: { view: 'citation-only', download: 'none' },
      administrative: { hasAdminPolicy: fetch_month.collection.admin_policy },
      identification: { sourceId: source_id },
      structural: structural
    }
  end

  def structural
    {
      isMemberOf: [fetch_month.collection.druid],
      contains: resources_props
    }
  end

  def source_id
    # sul:[wasapi provider]-[collectionId]-[YYYY]_[MM]
    date_part = "#{fetch_month.year}_#{fetch_month.month.to_s.rjust(2, '0')}"
    "sul:#{fetch_month.collection.wasapi_provider}-#{fetch_month.collection.wasapi_collection_id}-#{date_part}"
  end

  def resources_props
    warc_filepaths.map { |filepath| resource_props(filepath) }
  end

  def resource_props(filepath)
    filename = File.basename(filepath)
    {
      type: Cocina::Models::FileSetType.file,
      version: 1,
      label: filename,
      structural: {
        contains: [file_props(filepath, filename)]
      }
    }
  end

  # rubocop:disable Metrics/MethodLength
  def file_props(filepath, filename)
    {
      type: Cocina::Models::ObjectType.file,
      label: filename,
      filename: filename,
      size: File.size(filepath),
      version: 1,
      hasMimeType: 'application/warc',
      hasMessageDigests: message_digests(filepath),
      access: {},
      administrative: administrative
    }
  end
  # rubocop:enable Metrics/MethodLength

  def message_digests(filepath)
    [
      { type: 'md5', digest: Digest::MD5.file(filepath).hexdigest },
      { type: 'sha1', digest: Digest::SHA1.file(filepath).hexdigest }
    ]
  end

  def administrative
    {
      publish: false,
      sdrPreserve: true,
      shelve: world?
    }
  end

  def warc_filepaths
    # Note that any file hierarchy is discarded.
    Dir.glob("#{fetch_month.crawl_directory}/**/*.warc*")
  end

  def world?
    @world ||= begin
      apo = Dor::Services::Client.object(fetch_month.collection.admin_policy).find
      view = apo.administrative&.accessTemplate&.view
      # If the view access is anything other than world, it's dark.
      view == 'world'
    end
  end
end
