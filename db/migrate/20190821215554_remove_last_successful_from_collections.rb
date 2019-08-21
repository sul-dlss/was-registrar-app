# frozen_string_literal: true

class RemoveLastSuccessfulFromCollections < ActiveRecord::Migration[6.0]
  def change
    remove_column :collections, :last_successful_fetch
    remove_column :collections, :last_fetch_succeeded
  end
end
