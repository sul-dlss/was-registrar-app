# frozen_string_literal: true

# Builds a RequestDRO for registering a crawl.
class RequestBuilder
  def self.build(title:, source_id:, admin_policy:, collection:, crawl_directory:)
    new(title:, source_id:, admin_policy:, collection:,
        crawl_directory:).build
  end

  def initialize(title:, source_id:, admin_policy:, collection:, crawl_directory:)
    @title = title
    @source_id = source_id
    @admin_policy = admin_policy
    @collection = collection
    @crawl_directory = crawl_directory
  end

  def build
    Cocina::Models::RequestDRO.new(props)
  end

  private

  attr_reader :title, :source_id, :admin_policy, :collection, :crawl_directory

  def props
    {
      type: Cocina::Models::ObjectType.webarchive_binary,
      label: title,
      version: 1,
      description: { title: [{ value: title }] },
      access: { view: 'citation-only', download: 'none' },
      administrative: { hasAdminPolicy: admin_policy },
      identification: { sourceId: source_id },
      structural:
    }
  end

  def structural
    {
      isMemberOf: [collection],
      contains: resources_props
    }
  end

  def resources_props
    web_archive_filepaths.map { |filepath| resource_props_for(filepath) }
  end

  def resource_props_for(filepath)
    filename = File.basename(filepath)
    {
      type: Cocina::Models::FileSetType.file,
      version: 1,
      label: filename,
      structural: {
        contains: [file_props_for(filepath, filename)]
      }
    }
  end

  # rubocop:disable Metrics/MethodLength
  def file_props_for(filepath, filename)
    {
      type: Cocina::Models::ObjectType.file,
      label: filename,
      filename:,
      size: File.size(filepath),
      version: 1,
      hasMimeType: mime_type(filename),
      hasMessageDigests: message_digests(filepath),
      access: {},
      administrative:
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

  def web_archive_filepaths
    # Note that any file hierarchy is discarded.
    WebArchiveGlob.web_archives(crawl_directory)
  end

  def world?
    @world ||= begin
      apo = Dor::Services::Client.object(admin_policy).find
      view = apo.administrative&.accessTemplate&.view
      # If the view access is anything other than world, it's dark.
      view == 'world'
    end
  end

  def mime_type(filename)
    filename.end_with?('.wacz') ? 'application/wacz' : 'application/warc'
  end
end
