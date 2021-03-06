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

ActiveRecord::Schema.define(:version => 20120502124731) do

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

  create_table "black_listed_items", :force => true do |t|
    t.integer  "company_id"
    t.integer  "item_id"
    t.string   "item_type"
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
    t.string   "commercial_register_entry"
    t.string   "vat_id"
    t.string   "custom_category"
  end

  create_table "companies_company_roles", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "company_role_id"
  end

  create_table "company_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_roles_freights", :id => false, :force => true do |t|
    t.integer "freight_id"
    t.integer "company_role_id"
  end

  create_table "company_roles_loading_spaces", :id => false, :force => true do |t|
    t.integer "loading_space_id"
    t.integer "company_role_id"
  end

  create_table "freights", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "origin_site_info_id"
    t.integer  "destination_site_info_id"
    t.integer  "total_weight"
    t.integer  "loading_meter"
    t.boolean  "hazmat"
    t.string   "transport_type"
    t.string   "wagons_provided_by"
    t.string   "desired_proposal_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contact_person_id"
    t.integer  "transport_weight"
    t.integer  "transports_per_year"
    t.string   "paying_freight",                    :default => "sender"
    t.string   "frequency"
    t.boolean  "deleted",                           :default => false
    t.datetime "origin_date"
    t.integer  "origin_station_id"
    t.string   "origin_contractor"
    t.string   "origin_name"
    t.string   "origin_address"
    t.string   "origin_address2"
    t.string   "origin_zip"
    t.string   "origin_city"
    t.string   "origin_country"
    t.boolean  "origin_side_track_available"
    t.string   "origin_track_number"
    t.datetime "destination_date"
    t.integer  "destination_station_id"
    t.string   "destination_contractor"
    t.string   "destination_name"
    t.string   "destination_address"
    t.string   "destination_address2"
    t.string   "destination_zip"
    t.string   "destination_city"
    t.string   "destination_country"
    t.boolean  "destination_side_track_available"
    t.string   "destination_track_number"
    t.integer  "reply_to_id"
    t.string   "contractor"
    t.datetime "valid_until"
    t.string   "product_name"
    t.string   "product_state"
    t.string   "hazmat_class"
    t.string   "un_no"
    t.string   "nhm_no"
    t.datetime "first_transport_at"
    t.string   "desired_means_of_transport"
    t.string   "desired_means_of_transport_custom"
    t.string   "own_means_of_transport"
    t.string   "own_means_of_transport_custom"
    t.boolean  "own_means_of_transport_present",    :default => false
    t.text     "requirements_means_of_transport"
    t.text     "requirements_at_loading"
    t.text     "requirements_at_unloading"
    t.string   "custom_category"
    t.datetime "last_transport_at"
    t.integer  "parent_id"
    t.datetime "valid_from"
    t.integer  "transport_count",                   :default => 1
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
    t.integer  "transport_weight"
    t.integer  "transports_per_year"
    t.string   "paying_freight",                   :default => "sender"
    t.string   "frequency"
    t.boolean  "deleted",                          :default => false
    t.datetime "origin_date"
    t.integer  "origin_station_id"
    t.string   "origin_contractor"
    t.string   "origin_name"
    t.string   "origin_address"
    t.string   "origin_address2"
    t.string   "origin_zip"
    t.string   "origin_city"
    t.string   "origin_country"
    t.boolean  "origin_side_track_available"
    t.string   "origin_track_number"
    t.datetime "destination_date"
    t.integer  "destination_station_id"
    t.string   "destination_contractor"
    t.string   "destination_name"
    t.string   "destination_address"
    t.string   "destination_address2"
    t.string   "destination_zip"
    t.string   "destination_city"
    t.string   "destination_country"
    t.boolean  "destination_side_track_available"
    t.string   "destination_track_number"
    t.integer  "reply_to_id"
    t.string   "contractor"
    t.datetime "valid_until"
    t.datetime "first_transport_at"
    t.string   "own_means_of_transport"
    t.string   "own_means_of_transport_custom"
    t.boolean  "own_means_of_transport_present",   :default => false
    t.string   "free_capacities"
    t.string   "custom_category"
    t.datetime "last_transport_at"
    t.integer  "parent_id"
    t.datetime "valid_from"
    t.integer  "transport_count",                  :default => 1
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

  create_table "notification_condition_sets", :force => true do |t|
    t.integer  "company_id"
    t.integer  "user_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notification_conditions", :force => true do |t|
    t.integer  "notification_condition_set_id"
    t.string   "type"
    t.string   "attribute_name"
    t.string   "qualifier",                     :default => "equal"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notification_items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "notification_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "viewed",          :default => false
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "sent",       :default => false
    t.datetime "closed_at"
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
    t.integer  "station_id"
  end

  create_table "stations", :force => true do |t|
    t.string   "name"
    t.string   "numeric_id"
    t.string   "address"
    t.string   "address2"
    t.string   "zip"
    t.string   "city"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "password_reset_key"
    t.boolean  "notify_by_email",     :default => false
  end

  create_table "white_listed_items", :force => true do |t|
    t.integer  "company_id"
    t.integer  "item_id"
    t.string   "item_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
