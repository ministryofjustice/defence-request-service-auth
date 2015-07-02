# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150615132436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"
  enable_extension "uuid-ossp"

  create_table "government_applications", force: :cascade do |t|
    t.string   "oauth_application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "organisation_id"
    t.integer  "user_id"
    t.jsonb    "permissions",     default: {}
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "memberships", ["organisation_id", "user_id"], name: "index_memberships_on_organisation_id_and_user_id", unique: true, using: :btree
  add_index "memberships", ["organisation_id"], name: "index_memberships_on_organisation_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "organisations", force: :cascade do |t|
    t.string   "slug",                                                  null: false
    t.string   "name",                                                  null: false
    t.string   "organisation_type",                                     null: false
    t.boolean  "searchable",             default: false,                null: false
    t.string   "tel"
    t.text     "address"
    t.string   "postcode"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mobile"
    t.uuid     "uid",                    default: "uuid_generate_v4()"
    t.integer  "parent_organisation_id"
    t.jsonb    "details",                default: {}
  end

  add_index "organisations", ["details"], name: "index_organisations_on_details", using: :gin
  add_index "organisations", ["parent_organisation_id"], name: "index_organisations_on_parent_organisation_id", using: :btree
  add_index "organisations", ["uid"], name: "index_organisations_on_uid", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.integer  "organisation_id"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",                                      null: false
    t.string   "tel"
    t.text     "address"
    t.string   "postcode"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mobile"
    t.uuid     "uid",        default: "uuid_generate_v4()"
  end

  add_index "profiles", ["uid"], name: "index_profiles_on_uid", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",                   null: false
    t.string   "encrypted_password",     default: "",                   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,                    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                                                  null: false
    t.string   "telephone"
    t.string   "mobile"
    t.string   "address"
    t.string   "postcode"
    t.uuid     "uid",                    default: "uuid_generate_v4()"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "memberships", "organisations"
  add_foreign_key "memberships", "users"
end
