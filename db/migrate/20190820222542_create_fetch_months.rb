# frozen_string_literal: true

class CreateFetchMonths < ActiveRecord::Migration[6.0]
  def change
    create_table :fetch_months do |t|
      t.string :collection_id, null: false
      t.integer :year, null: false
      t.integer :month, null: false
      t.string :status, null: false
      t.text :failure_reason
      t.string :crawl_item_druid, unique: true
      t.timestamps
      t.index ['crawl_item_druid'], unique: true
      t.index %w[collection_id year month], unique: true
    end
    add_foreign_key :fetch_months, :collections, column: :collection_id, primary_key: :druid
  end
end
