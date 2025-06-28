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

ActiveRecord::Schema[8.0].define(version: 2025_06_22_162329) do
  create_schema "auth"
  create_schema "extensions"
  create_schema "graphql"
  create_schema "graphql_public"
  create_schema "pgbouncer"
  create_schema "realtime"
  create_schema "storage"
  create_schema "vault"

  # These are extensions that must be enabled in order to support this database
  enable_extension "extensions.pg_stat_statements"
  enable_extension "extensions.pgcrypto"
  enable_extension "extensions.uuid-ossp"
  enable_extension "pg_catalog.plpgsql"

  create_table "dns_records", force: :cascade do |t|
    t.text "cname_record"
    t.text "mx_record"
    t.text "ns_record"
    t.bigint "subdomain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subdomain_id"], name: "index_dns_records_on_subdomain_id", unique: true
  end

  create_table "domains", force: :cascade do |t|
    t.string "domain"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain"], name: "index_domains_on_domain", unique: true
    t.index ["user_id"], name: "index_domains_on_user_id"
  end

  create_table "enumeration_scan_results", force: :cascade do |t|
    t.string "name"
    t.text "webserver"
    t.jsonb "technologies"
    t.jsonb "ip"
    t.text "title"
    t.integer "status_code"
    t.integer "port"
    t.text "asn"
    t.integer "content_length"
    t.jsonb "cname"
    t.text "url"
    t.bigint "enumeration_scan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["enumeration_scan_id"], name: "index_enumeration_scan_results_on_enumeration_scan_id"
  end

  create_table "enumeration_scans", force: :cascade do |t|
    t.string "name"
    t.datetime "completed_at"
    t.string "status"
    t.text "failure_reason"
    t.integer "total_assets"
    t.string "scan_time_elapsed"
    t.bigint "domain_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_enumeration_scans_on_domain_id"
    t.index ["user_id"], name: "index_enumeration_scans_on_user_id"
  end

  create_table "identities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.string "name"
    t.string "email"
    t.string "image"
    t.string "token"
    t.string "refresh_token"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "ip_addresses", force: :cascade do |t|
    t.string "ip_address"
    t.string "asn"
    t.string "org"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address"], name: "index_ip_addresses_on_ip_address", unique: true
  end

  create_table "open_ports", force: :cascade do |t|
    t.integer "port_number"
    t.boolean "is_web"
    t.bigint "ip_address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address_id"], name: "index_open_ports_on_ip_address_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "subdomain_ips", force: :cascade do |t|
    t.datetime "resolved_on"
    t.bigint "subdomain_id", null: false
    t.bigint "ip_address_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address_id"], name: "index_subdomain_ips_on_ip_address_id"
    t.index ["subdomain_id", "ip_address_id"], name: "index_subdomain_ips_on_subdomain_and_ip", unique: true
    t.index ["subdomain_id"], name: "index_subdomain_ips_on_subdomain_id"
  end

  create_table "subdomains", force: :cascade do |t|
    t.string "subdomain"
    t.datetime "first_seen"
    t.datetime "last_seen"
    t.string "dns_status"
    t.boolean "is_web"
    t.bigint "domain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_subdomains_on_domain_id"
    t.index ["subdomain"], name: "index_subdomains_on_subdomain", unique: true
  end

  create_table "technologies", force: :cascade do |t|
    t.string "name"
    t.string "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "verified_at"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "vulnerability_scan_results", force: :cascade do |t|
    t.jsonb "vuln_data"
    t.string "severity"
    t.string "host"
    t.bigint "vulnerability_scan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["vulnerability_scan_id"], name: "index_vulnerability_scan_results_on_vulnerability_scan_id"
  end

  create_table "vulnerability_scans", force: :cascade do |t|
    t.string "name"
    t.datetime "completed_at"
    t.integer "progress"
    t.jsonb "severity"
    t.string "status"
    t.text "failure_reason"
    t.boolean "is_rescan"
    t.string "scan_time_elapsed"
    t.bigint "domain_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["domain_id"], name: "index_vulnerability_scans_on_domain_id"
    t.index ["user_id"], name: "index_vulnerability_scans_on_user_id"
  end

  create_table "webservers", force: :cascade do |t|
    t.integer "port_number"
    t.string "name"
    t.text "title"
    t.integer "status_code"
    t.bigint "content_length"
    t.text "url"
    t.bigint "subdomain_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subdomain_id", "port_number"], name: "index_webservers_on_subdomain_id_and_port_number", unique: true
    t.index ["subdomain_id"], name: "index_webservers_on_subdomain_id"
  end

  create_table "webservers_technologies", force: :cascade do |t|
    t.bigint "webserver_id", null: false
    t.bigint "technology_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["technology_id"], name: "index_webservers_technologies_on_technology_id"
    t.index ["webserver_id", "technology_id"], name: "index_webservers_technologies_on_webserver_and_tech", unique: true
    t.index ["webserver_id"], name: "index_webservers_technologies_on_webserver_id"
  end

  add_foreign_key "dns_records", "subdomains"
  add_foreign_key "domains", "users"
  add_foreign_key "enumeration_scan_results", "enumeration_scans"
  add_foreign_key "enumeration_scans", "domains"
  add_foreign_key "enumeration_scans", "users"
  add_foreign_key "identities", "users"
  add_foreign_key "open_ports", "ip_addresses"
  add_foreign_key "sessions", "users"
  add_foreign_key "subdomain_ips", "ip_addresses"
  add_foreign_key "subdomain_ips", "subdomains"
  add_foreign_key "subdomains", "domains"
  add_foreign_key "vulnerability_scan_results", "vulnerability_scans"
  add_foreign_key "vulnerability_scans", "domains"
  add_foreign_key "vulnerability_scans", "users"
  add_foreign_key "webservers", "subdomains"
  add_foreign_key "webservers_technologies", "technologies"
  add_foreign_key "webservers_technologies", "webservers"
end
