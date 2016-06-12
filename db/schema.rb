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

ActiveRecord::Schema.define(version: 20160609185458) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "accounts", ["organization_id"], name: "index_accounts_on_organization_id", using: :btree

  create_table "accounts_users", force: :cascade do |t|
    t.integer "account_id"
    t.integer "user_id"
  end

  add_index "accounts_users", ["account_id"], name: "index_accounts_users_on_account_id", using: :btree
  add_index "accounts_users", ["user_id"], name: "index_accounts_users_on_user_id", using: :btree

  create_table "credentials", force: :cascade do |t|
    t.integer  "provider_id"
    t.string   "encrypted_token"
    t.string   "encrypted_token_salt"
    t.string   "encrypted_token_iv"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "account_id"
    t.hstore   "data"
  end

  add_index "credentials", ["account_id"], name: "index_credentials_on_account_id", using: :btree
  add_index "credentials", ["data"], name: "index_credentials_on_data", using: :gin
  add_index "credentials", ["provider_id"], name: "index_credentials_on_provider_id", using: :btree

  create_table "deployments", force: :cascade do |t|
    t.integer  "template_id"
    t.string   "region",                     default: "", null: false
    t.string   "machine_type",               default: "", null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "image",                      default: "", null: false
    t.string   "network_id"
    t.string   "instance_id"
    t.string   "key_name"
    t.text     "encrypted_public_key"
    t.string   "encrypted_public_key_salt"
    t.string   "encrypted_public_key_iv"
    t.text     "encrypted_private_key"
    t.string   "encrypted_private_key_salt"
    t.string   "encrypted_private_key_iv"
    t.string   "ssh_user"
    t.string   "state"
    t.text     "error"
    t.string   "failed_state"
    t.integer  "accounts_user_id"
    t.hstore   "credentials"
    t.integer  "provider_id"
    t.hstore   "arguments"
  end

  add_index "deployments", ["accounts_user_id"], name: "index_deployments_on_accounts_user_id", using: :btree
  add_index "deployments", ["arguments"], name: "index_deployments_on_arguments", using: :gin
  add_index "deployments", ["provider_id"], name: "index_deployments_on_provider_id", using: :btree
  add_index "deployments", ["template_id"], name: "index_deployments_on_template_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "provider_settings", force: :cascade do |t|
    t.string   "name"
    t.string   "encrypted_value"
    t.string   "encrypted_value_salt"
    t.string   "encrypted_value_iv"
    t.integer  "provider_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "provider_settings", ["provider_id"], name: "index_provider_settings_on_provider_id", using: :btree

  create_table "providers", force: :cascade do |t|
    t.string   "name"
    t.string   "textkey"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "organization_id"
    t.boolean  "configured",      default: false
  end

  add_index "providers", ["organization_id"], name: "index_providers_on_organization_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "template_arguments", force: :cascade do |t|
    t.string   "textkey"
    t.string   "name"
    t.boolean  "required",    default: false
    t.string   "default"
    t.integer  "template_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "validator"
  end

  add_index "template_arguments", ["template_id"], name: "index_template_arguments_on_template_id", using: :btree

  create_table "templates", force: :cascade do |t|
    t.string   "name"
    t.string   "os"
    t.text     "script"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "templates", ["name"], name: "index_templates_on_name", using: :btree
  add_index "templates", ["os"], name: "index_templates_on_os", using: :btree
  add_index "templates", ["user_id"], name: "index_templates_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             default: "",    null: false
    t.string   "last_name",              default: "",    null: false
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false, null: false
    t.integer  "current_account_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["current_account_id"], name: "index_users_on_current_account_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "accounts", "organizations"
  add_foreign_key "accounts_users", "accounts"
  add_foreign_key "accounts_users", "users"
  add_foreign_key "credentials", "accounts"
  add_foreign_key "credentials", "providers"
  add_foreign_key "deployments", "accounts_users"
  add_foreign_key "deployments", "providers"
  add_foreign_key "provider_settings", "providers"
  add_foreign_key "providers", "organizations"
  add_foreign_key "template_arguments", "templates"
  add_foreign_key "templates", "users"
end
