# frozen_string_literal: true

class AddWasapiCollectionIdToCollection < ActiveRecord::Migration[6.0]
  def change
    add_column :collections, :wasapi_collection_id, :string, null: false
  end
end
