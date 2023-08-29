# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Collection.create(title: 'Test Collection',
                  druid: Settings.default_setup.collection,
                  admin_policy: Settings.default_setup.admin_policy,
                  embargo_months: Settings.default_setup.embargo_months,
                  active: true,
                  wasapi_provider: Settings.default_setup.wasapi_provider,
                  wasapi_account: Settings.default_setup.wasapi_account,
                  wasapi_collection_id: Settings.default_setup.wasapi_collection_id,
                  fetch_start_month: Settings.default_setup.fetch_start_month)
