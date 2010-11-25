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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101112220631) do

  create_table "action_recordings", :force => true do |t|
    t.string   "item_type",  :limit => 30
    t.integer  "item_id"
    t.string   "action",     :limit => 10
    t.text     "diff"
    t.integer  "user_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_configs", :force => true do |t|
    t.string   "name"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "fax"
    t.string   "mobile"
    t.string   "email"
    t.string   "website"
    t.string   "address"
    t.string   "address2"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_person_id"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "iso",        :limit => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "freights", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "origin_site_info_id"
    t.integer  "destination_site_info_id"
    t.integer  "weight"
    t.integer  "loading_meter"
    t.boolean  "hazmat"
    t.string   "transport_type"
    t.string   "wagons_provided_by"
    t.string   "desired_proposal_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_person_id"
  end

  create_table "loading_spaces", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "origin_site_info_id"
    t.integer  "destination_site_info_id"
    t.integer  "weight"
    t.integer  "loading_meter"
    t.boolean  "hazmat"
    t.string   "transport_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_person_id"
  end

  create_table "localized_infos", :force => true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.string   "name"
    t.string   "lang"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "matching_recordings", :force => true do |t|
    t.string   "a_type",     :limit => 30
    t.integer  "a_id"
    t.string   "b_type",     :limit => 30
    t.integer  "b_id"
    t.float    "result"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.string   "job_description"
    t.string   "phone"
    t.string   "fax"
    t.string   "mobile"
    t.string   "email"
    t.string   "website"
    t.string   "locale",          :default => "en"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recordings", :force => true do |t|
    t.string   "item_type",  :limit => 30
    t.integer  "item_id"
    t.string   "action",     :limit => 10
    t.text     "diff"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "company_id"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions_stations", :id => false, :force => true do |t|
    t.integer "region_id"
    t.integer "station_id"
  end

  create_table "reviews", :force => true do |t|
    t.integer  "author_user_id"
    t.integer  "author_company_id"
    t.integer  "approved_by_id"
    t.integer  "company_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_recordings", :force => true do |t|
    t.integer  "user_id"
    t.string   "query"
    t.integer  "results"
    t.integer  "parent_id"
    t.string   "result_type", :limit => 30
    t.integer  "result_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "simple_searches", :force => true do |t|
    t.string   "item_type"
    t.integer  "item_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_infos", :force => true do |t|
    t.string   "contractor"
    t.datetime "date"
    t.string   "name"
    t.string   "address"
    t.string   "address2"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.boolean  "side_track_available"
    t.string   "track_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stations", :force => true do |t|
    t.string   "name"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.string   "address2"
    t.string   "zip"
    t.string   "city"
  end

  create_table "tolk_locales", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tolk_locales", ["name"], :name => "index_tolk_locales_on_name", :unique => true

  create_table "tolk_phrases", :force => true do |t|
    t.text     "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tolk_translations", :force => true do |t|
    t.integer  "phrase_id"
    t.integer  "locale_id"
    t.text     "text"
    t.text     "previous_text"
    t.boolean  "primary_updated", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tolk_translations", ["phrase_id", "locale_id"], :name => "index_tolk_translations_on_phrase_id_and_locale_id", :unique => true

  create_table "user_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "user_role_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                      :null => false
    t.string   "email",                                      :null => false
    t.string   "crypted_password",                           :null => false
    t.string   "password_salt",                              :null => false
    t.string   "persistence_token",                          :null => false
    t.string   "single_access_token",                        :null => false
    t.string   "perishable_token",                           :null => false
    t.integer  "login_count",         :default => 0,         :null => false
    t.integer  "failed_login_count",  :default => 0,         :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.integer  "person_id"
    t.string   "api_key"
    t.string   "posting_type",        :default => "Freight"
  end

end
