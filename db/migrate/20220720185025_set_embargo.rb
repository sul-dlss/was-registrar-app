# frozen_string_literal: true

class SetEmbargo < ActiveRecord::Migration[7.0]
  def change
    Collection.connection.execute('UPDATE collections SET embargo_months = 1 WHERE embargo_months = 0')
  end
end
