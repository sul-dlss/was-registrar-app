# frozen_string_literal: true

class AddAdminPolicyToCollections < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_policies do |t|
      t.string :collection_id, null: false
      t.string :druid
      t.string :name
    end
    add_column :collections, :admin_policy, :string
  end
end
