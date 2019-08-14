# frozen_string_literal: true

class AddUniqueKeyDruid < ActiveRecord::Migration[5.2]
  def change
    add_index :collections, :druid, unique: true
  end
end
