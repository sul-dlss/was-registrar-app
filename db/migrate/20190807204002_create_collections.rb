# frozen_string_literal: true

class CreateCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :collections do |t|
      t.string :title
      t.string :druid
      t.integer :embargo_months
      t.datetime :last_successful_fetch
      t.boolean :last_fetch_succeeded
      t.boolean :active

      t.timestamps
    end
  end
end
