# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_29_162547) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collections", force: :cascade do |t|
    t.string "title"
    t.string "druid"
    t.integer "embargo_months"
    t.boolean "active"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "wasapi_provider"
    t.string "wasapi_account"
    t.date "fetch_start_month", null: false
    t.string "wasapi_collection_id", null: false
    t.string "admin_policy", default: "druid:wr005wn5739"
    t.index ["wasapi_provider", "wasapi_account", "wasapi_collection_id"], name: "index_collections_on_wasapi", unique: true
  end

  create_table "fetch_months", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.integer "year", null: false
    t.integer "month", null: false
    t.string "status", null: false
    t.text "failure_reason"
    t.string "crawl_item_druid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id", "year", "month"], name: "index_fetch_months_on_collection_id_and_year_and_month", unique: true
    t.index ["collection_id"], name: "index_fetch_months_on_collection_id"
    t.index ["crawl_item_druid"], name: "index_fetch_months_on_crawl_item_druid", unique: true
  end

  create_table "registration_jobs", force: :cascade do |t|
    t.string "collection", null: false
    t.string "admin_policy", default: "druid:wr005wn5739"
    t.string "source_id", null: false
    t.string "job_directory", null: false
    t.string "status", default: "waiting", null: false
    t.text "failure_reason"
    t.string "crawl_item_druid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crawl_item_druid"], name: "index_registration_jobs_on_crawl_item_druid", unique: true
  end

  add_foreign_key "fetch_months", "collections"
end
