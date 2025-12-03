# frozen_string_literal: true

module Audit
  # Enumberable that returns WARC filenames for a collection from SDR.
  class SdrWarcLister
    include Enumerable

    def initialize(collection_druid:)
      @collection_druid = collection_druid
    end

    def each(&block)
      if block_given?
        member_druids.each do |member_druid|
          files_for(member_druid).each { |file| block.call(file) }
        end
      else
        to_enum(:each)
      end
    end

    private

    attr_reader :collection_druid

    def member_druids
      Dor::Services::Client.object(collection_druid).members.map(&:externalIdentifier)
    end

    def files_for(member_druid)
      cocina_obj = Dor::Services::Client.object(member_druid).find
      return [] if cocina_obj.type == Cocina::Models::ObjectType.webarchive_seed

      cocina_obj.structural.contains.flat_map do |resource|
        resource.structural.contains.map(&:filename)
      end
    end
  end
end
