# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_15_122490) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "buildings", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_buildings_on_company_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.integer "zip"
    t.string "parent_id"
    t.bigint "us_state_id"
    t.bigint "owner_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_companies_on_owner_id"
    t.index ["us_state_id"], name: "index_companies_on_us_state_id"
  end

  create_table "company_agreements", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "url"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_agreements_on_company_id"
  end

  create_table "company_agreements_vendors", force: :cascade do |t|
    t.bigint "vendor_id"
    t.bigint "company_agreement_id"
    t.datetime "date_signed", default: -> { "CURRENT_TIMESTAMP" }
    t.index ["company_agreement_id"], name: "index_company_agreements_vendors_on_company_agreement_id"
    t.index ["vendor_id"], name: "index_company_agreements_vendors_on_vendor_id"
  end

  create_table "company_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_company_users_on_company_id"
    t.index ["user_id"], name: "index_company_users_on_user_id"
  end

  create_table "company_vendor_agencies", force: :cascade do |t|
    t.bigint "vendor_agency_id"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_company_vendor_agencies_on_company_id"
    t.index ["vendor_agency_id"], name: "index_company_vendor_agencies_on_vendor_agency_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_departments_on_company_id"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name"
    t.string "identifier"
    t.string "identifier_type"
    t.string "device_mode"
    t.string "model_number"
    t.string "description"
    t.string "printer_type"
    t.string "printer_connection"
    t.string "printer_status"
    t.string "restart_time"
    t.bigint "building_id"
    t.bigint "company_id"
    t.datetime "last_sync_at"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_devices_on_building_id"
    t.index ["company_id"], name: "index_devices_on_company_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "title"
    t.string "email"
    t.string "phone_num"
    t.bigint "company_id"
    t.bigint "department_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_employees_on_company_id"
    t.index ["department_id"], name: "index_employees_on_department_id"
  end

  create_table "guest_companies", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "guest_id"
    t.index ["company_id"], name: "index_guest_companies_on_company_id"
    t.index ["guest_id"], name: "index_guest_companies_on_guest_id"
  end

  create_table "guests", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone_num"
    t.integer "pin"
    t.integer "status"
    t.bigint "us_state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "guest_type"
    t.index ["us_state_id"], name: "index_guests_on_us_state_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "name"
    t.string "address1"
    t.string "address2"
    t.string "phone"
    t.bigint "us_state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_key"
    t.index ["us_state_id"], name: "index_owners_on_us_state_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "role_permissions", force: :cascade do |t|
    t.bigint "permission_id"
    t.bigint "role_id"
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_types", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "us_states", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "status"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vendor_agencies", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "business_type"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.bigint "us_state_id"
    t.integer "zip"
    t.integer "parent_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_num"
    t.string "email"
    t.index ["us_state_id"], name: "index_vendor_agencies_on_us_state_id"
  end

  create_table "vendor_companies", force: :cascade do |t|
    t.bigint "company_id"
    t.bigint "vendor_id"
    t.index ["company_id"], name: "index_vendor_companies_on_company_id"
    t.index ["vendor_id"], name: "index_vendor_companies_on_vendor_id"
  end

  create_table "vendor_vendor_agencies", force: :cascade do |t|
    t.bigint "vendor_agency_id"
    t.bigint "vendor_id"
    t.index ["vendor_agency_id"], name: "index_vendor_vendor_agencies_on_vendor_agency_id"
    t.index ["vendor_id"], name: "index_vendor_vendor_agencies_on_vendor_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_num"
    t.integer "pin"
    t.boolean "phone_verified"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "us_state_id"
    t.index ["us_state_id"], name: "index_vendors_on_us_state_id"
  end

  create_table "visit_notes", force: :cascade do |t|
    t.bigint "visit_id"
    t.string "before_visit"
    t.string "after_visit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["visit_id"], name: "index_visit_notes_on_visit_id"
  end

  create_table "visits", force: :cascade do |t|
    t.integer "visitor_type"
    t.integer "visitor_id"
    t.string "person_name"
    t.date "on_date"
    t.time "tentative_time"
    t.bigint "device_id"
    t.bigint "company_id"
    t.bigint "department_id"
    t.time "start_time"
    t.time "end_time"
    t.string "purpose"
    t.bigint "service_type_id"
    t.integer "visit_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.binary "qr_code"
    t.index ["company_id"], name: "index_visits_on_company_id"
    t.index ["department_id"], name: "index_visits_on_department_id"
    t.index ["device_id"], name: "index_visits_on_device_id"
    t.index ["service_type_id"], name: "index_visits_on_service_type_id"
  end

  add_foreign_key "buildings", "companies"
  add_foreign_key "companies", "owners"
  add_foreign_key "companies", "us_states"
  add_foreign_key "company_agreements", "companies"
  add_foreign_key "company_agreements_vendors", "company_agreements"
  add_foreign_key "company_agreements_vendors", "vendors"
  add_foreign_key "company_users", "companies"
  add_foreign_key "company_users", "users"
  add_foreign_key "company_vendor_agencies", "companies"
  add_foreign_key "company_vendor_agencies", "vendor_agencies"
  add_foreign_key "departments", "companies"
  add_foreign_key "devices", "buildings"
  add_foreign_key "devices", "companies"
  add_foreign_key "employees", "companies"
  add_foreign_key "employees", "departments"
  add_foreign_key "guest_companies", "companies"
  add_foreign_key "guest_companies", "guests"
  add_foreign_key "guests", "us_states"
  add_foreign_key "owners", "us_states"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "vendor_agencies", "us_states"
  add_foreign_key "vendor_companies", "companies"
  add_foreign_key "vendor_companies", "vendors"
  add_foreign_key "vendor_vendor_agencies", "vendor_agencies"
  add_foreign_key "vendor_vendor_agencies", "vendors"
  add_foreign_key "vendors", "us_states"
  add_foreign_key "visit_notes", "visits"
  add_foreign_key "visits", "companies"
  add_foreign_key "visits", "departments"
  add_foreign_key "visits", "devices"
  add_foreign_key "visits", "service_types"
end
