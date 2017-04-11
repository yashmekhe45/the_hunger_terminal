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

ActiveRecord::Schema.define(version: 20170322104724) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "house_no"
    t.integer  "pincode"
    t.string   "locality"
    t.string   "city"
    t.string   "state"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "location_type"
    t.integer  "location_id"
    t.index ["location_type", "location_id"], name: "index_addresses_on_location_type_and_location_id", using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "landline"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.time     "start_ordering_at"
    t.time     "review_ordering_at"
    t.time     "end_ordering_at"
    t.string   "email"
    t.float    "subsidy"
  end

  create_table "menu_items", force: :cascade do |t|
    t.string   "name"
    t.boolean  "veg"
    t.integer  "price"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "terminal_id"
    t.boolean  "available",   default: true
    t.string   "active_days", default: [],                array: true
    t.text     "description"
    t.index ["terminal_id"], name: "index_menu_items_on_terminal_id", using: :btree
  end

  create_table "order_details", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "menu_item_name"
    t.integer  "price"
    t.integer  "quantity"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "menu_item_id"
    t.string   "status"
    t.index ["menu_item_id"], name: "index_order_details_on_menu_item_id", using: :btree
    t.index ["order_id"], name: "index_order_details_on_order_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.date     "date"
    t.integer  "total_cost"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "terminal_id"
    t.string   "status"
    t.float    "discount"
    t.index ["company_id"], name: "index_orders_on_company_id", using: :btree
    t.index ["terminal_id"], name: "index_orders_on_terminal_id", using: :btree
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "terminals", force: :cascade do |t|
    t.string   "name"
    t.string   "landline"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "company_id"
    t.string   "email"  
    t.boolean  "active",           default: true
    t.string   "image"
    t.float    "min_order_amount"
    t.index ["company_id"], name: "index_terminals_on_company_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "mobile_number"
    t.string   "role"
    t.boolean  "is_active"
    t.integer  "company_id"
    t.index ["company_id"], name: "index_users_on_company_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "menu_items", "terminals"
  add_foreign_key "order_details", "menu_items"
  add_foreign_key "order_details", "orders"
  add_foreign_key "orders", "companies"
  add_foreign_key "orders", "terminals"
  add_foreign_key "orders", "users"
  add_foreign_key "terminals", "companies"
  add_foreign_key "users", "companies"
end
