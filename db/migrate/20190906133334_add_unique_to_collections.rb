# frozen_string_literal: true

class AddUniqueToCollections < ActiveRecord::Migration[6.0]
  def change
    add_index :collections, %i[wasapi_provider wasapi_account wasapi_collection_id],
              unique: true, name: 'index_collections_on_wasapi'
  end
end
