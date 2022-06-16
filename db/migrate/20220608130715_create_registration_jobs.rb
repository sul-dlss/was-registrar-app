# frozen_string_literal: true

class CreateRegistrationJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :registration_jobs do |t|
      t.string :collection, null: false
      t.string :admin_policy, default: 'druid:wr005wn5739'
      t.string :source_id, null: false
      t.string :job_directory, null: false
      t.string :status, null: false, default: 'waiting'
      t.text :failure_reason
      t.string :crawl_item_druid, unique: true

      t.timestamps
      t.index ['crawl_item_druid'], unique: true
    end
  end
end
