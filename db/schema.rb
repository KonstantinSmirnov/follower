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

ActiveRecord::Schema.define(version: 20170323125246) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "users", force: :cascade do |t|
    t.string   "email",                           null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activation_state"
    t.string   "activation_token"
    t.datetime "activation_token_expires_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.index ["activation_token"], name: "index_users_on_activation_token", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", using: :btree
  end

  create_table "webpages", force: :cascade do |t|
    t.string   "url"
    t.string   "auth_hash"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "name"
    t.integer  "user_id"
    t.boolean  "has_script",        default: false
    t.string   "widget_token"
    t.string   "cart_url"
    t.string   "item_image_id"
    t.string   "item_sku_id"
    t.string   "item_name_id"
    t.string   "item_link_id"
    t.string   "item_quantity_id"
    t.string   "delivery_price_id"
    t.string   "cart_total_id"
  end

end
