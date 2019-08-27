# frozen_string_literal: true

class AddAdminPolicyToCollection < ActiveRecord::Migration[6.0]
  def change
    add_column :collections, :admin_policy, :string, default: 'druid:wr005wn5739'
  end
end
