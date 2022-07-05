# frozen_string_literal: true

# A one-time crawl registration.
class RegistrationJob < ApplicationRecord
  # Removes extra spaces
  auto_strip_attributes :collection, :source_id, :job_directory

  validates :collection, :source_id, :job_directory, presence: true
  validates :admin_policy, inclusion: { in: %w[druid:wr005wn5739 druid:yf700yh0557] }
  validates :status, inclusion: { in: %w[waiting running success failure] }
  validates :collection, format: { with: /\Adruid:[b-df-hjkmnp-tv-z]{2}[0-9]{3}[b-df-hjkmnp-tv-z]{2}[0-9]{4}\z/,
                                   message: 'must be a valid druid beginning with druid:' }
  validates :source_id, format: { with: /\A.+:.+\z/, message: 'must be namespace:identifier' }

  with_options if: proc { |registration_job| registration_job.status == 'waiting' } do
    validates :collection, collection_druid: true
    validates :source_id, unique_source_id: true
    validates :job_directory, job_directory: true
  end

  def crawl_directory
    File.join(Settings.crawl_directory, job_directory)
  end
end
