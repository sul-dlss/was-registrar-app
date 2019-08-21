# frozen_string_literal: true

class AddFetchStartMonthToCollection < ActiveRecord::Migration[6.0]
  def change
    add_column :collections, :fetch_start_month, :date, null: false
  end
end
