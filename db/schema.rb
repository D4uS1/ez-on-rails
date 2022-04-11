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

ActiveRecord::Schema.define(version: 2021_12_17_114421) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "assoc_tests", force: :cascade do |t|
    t.bigint "bearer_token_access_test_id", null: false
    t.bigint "parent_form_test_id", null: false
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["bearer_token_access_test_id"], name: "index_assoc_tests_on_bearer_token_access_test_id"
    t.index ["owner_id"], name: "index_assoc_tests_on_owner_id"
    t.index ["parent_form_test_id"], name: "index_assoc_tests_on_parent_form_test_id"
  end

  create_table "bearer_token_access_tests", force: :cascade do |t|
    t.string "test"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_bearer_token_access_tests_on_owner_id"
  end

  create_table "date_tests", force: :cascade do |t|
    t.date "date"
    t.datetime "datetime"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_date_tests_on_owner_id"
  end

  create_table "eor_group_accesses", force: :cascade do |t|
    t.string "namespace"
    t.string "controller"
    t.string "action"
    t.bigint "group_id", null: false
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "namespace", "controller", "action"], name: "eor_group_access_index", unique: true
    t.index ["group_id"], name: "index_eor_group_accesses_on_group_id"
    t.index ["owner_id"], name: "index_eor_group_accesses_on_owner_id"
  end

  create_table "eor_groups", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "eor_groups_index", unique: true
    t.index ["owner_id"], name: "index_eor_groups_on_owner_id"
    t.index ["user_id"], name: "index_eor_groups_on_user_id"
  end

  create_table "eor_ownership_infos", force: :cascade do |t|
    t.string "resource"
    t.boolean "sharable"
    t.integer "on_owner_destroy", default: 0
    t.integer "integer", default: 0
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_eor_ownership_infos_on_owner_id"
    t.index ["resource"], name: "eor_ownership_infos_index", unique: true
  end

  create_table "eor_resource_destroy_accesses", force: :cascade do |t|
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_eor_resource_destroy_accesses_on_group_id"
    t.index ["resource_type", "resource_id"], name: "index_eor_resource_destroy_accesses_on_resource"
  end

  create_table "eor_resource_read_accesses", force: :cascade do |t|
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_eor_resource_read_accesses_on_group_id"
    t.index ["resource_type", "resource_id"], name: "index_eor_resource_read_accesses_on_resource"
  end

  create_table "eor_resource_write_accesses", force: :cascade do |t|
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id"], name: "index_eor_resource_write_accesses_on_group_id"
    t.index ["resource_type", "resource_id"], name: "index_eor_resource_write_accesses_on_resource"
  end

  create_table "eor_user_group_assignments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_eor_user_group_assignments_on_group_id"
    t.index ["owner_id"], name: "index_eor_user_group_assignments_on_owner_id"
    t.index ["user_id", "group_id"], name: "eor_user_group_assignments_index", unique: true
    t.index ["user_id"], name: "index_eor_user_group_assignments_on_user_id"
  end

  create_table "json_schema_validator_tests", force: :cascade do |t|
    t.jsonb "test"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_json_schema_validator_tests_on_owner_id"
  end

  create_table "nested_form_tests", force: :cascade do |t|
    t.string "test_string"
    t.integer "test_int"
    t.boolean "test_bool"
    t.bigint "parent_form_test_id"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_nested_form_tests_on_owner_id"
    t.index ["parent_form_test_id"], name: "index_nested_form_tests_on_parent_form_test_id"
  end

  create_table "not_user_owned_records", force: :cascade do |t|
    t.string "test"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_not_user_owned_records_on_owner_id"
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.bigint "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["resource_owner_id"], name: "index_oauth_access_grants_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "oauth_client_access_tests", force: :cascade do |t|
    t.string "test"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_oauth_client_access_tests_on_owner_id"
  end

  create_table "parent_form_tests", force: :cascade do |t|
    t.string "test"
    t.boolean "test_bool"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_parent_form_tests_on_owner_id"
  end

  create_table "properties_tests", force: :cascade do |t|
    t.string "string_value"
    t.integer "integer_value"
    t.float "float_value"
    t.date "date_value"
    t.datetime "datetime_value"
    t.boolean "boolean_value"
    t.bigint "assoc_test_id", null: false
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assoc_test_id"], name: "index_properties_tests_on_assoc_test_id"
    t.index ["owner_id"], name: "index_properties_tests_on_owner_id"
  end

  create_table "sharable_resources", force: :cascade do |t|
    t.string "test"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_sharable_resources_on_owner_id"
  end

  create_table "user_owned_records", force: :cascade do |t|
    t.string "test"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_user_owned_records_on_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.json "tokens"
    t.boolean "privacy_policy_accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  create_table "validation_error_tests", force: :cascade do |t|
    t.string "name"
    t.integer "number"
    t.bigint "owner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["owner_id"], name: "index_validation_error_tests_on_owner_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "assoc_tests", "bearer_token_access_tests"
  add_foreign_key "assoc_tests", "parent_form_tests"
  add_foreign_key "assoc_tests", "users", column: "owner_id"
  add_foreign_key "bearer_token_access_tests", "users", column: "owner_id"
  add_foreign_key "date_tests", "users", column: "owner_id"
  add_foreign_key "eor_group_accesses", "eor_groups", column: "group_id"
  add_foreign_key "eor_group_accesses", "users", column: "owner_id"
  add_foreign_key "eor_groups", "users"
  add_foreign_key "eor_groups", "users", column: "owner_id"
  add_foreign_key "eor_ownership_infos", "users", column: "owner_id"
  add_foreign_key "eor_resource_destroy_accesses", "eor_groups", column: "group_id"
  add_foreign_key "eor_resource_read_accesses", "eor_groups", column: "group_id"
  add_foreign_key "eor_resource_write_accesses", "eor_groups", column: "group_id"
  add_foreign_key "eor_user_group_assignments", "eor_groups", column: "group_id"
  add_foreign_key "eor_user_group_assignments", "users"
  add_foreign_key "eor_user_group_assignments", "users", column: "owner_id"
  add_foreign_key "json_schema_validator_tests", "users", column: "owner_id"
  add_foreign_key "nested_form_tests", "parent_form_tests"
  add_foreign_key "nested_form_tests", "users", column: "owner_id"
  add_foreign_key "not_user_owned_records", "users", column: "owner_id"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "oauth_client_access_tests", "users", column: "owner_id"
  add_foreign_key "parent_form_tests", "users", column: "owner_id"
  add_foreign_key "properties_tests", "assoc_tests"
  add_foreign_key "properties_tests", "users", column: "owner_id"
  add_foreign_key "sharable_resources", "users", column: "owner_id"
  add_foreign_key "user_owned_records", "users", column: "owner_id"
  add_foreign_key "validation_error_tests", "users", column: "owner_id"
end
