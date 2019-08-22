# frozen_string_literal: true

class AddProviderAndAccountToCollection < ActiveRecord::Migration[6.0]
  def change
    add_column :collections, :wasapi_provider, :string
    add_column :collections, :wasapi_account, :string
  end
end
