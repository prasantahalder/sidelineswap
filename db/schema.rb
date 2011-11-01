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

ActiveRecord::Schema.define(:version => 20111031140307) do

  create_table "addresses", :force => true do |t|
    t.string   "first_name",                                        :null => false
    t.string   "last_name",                                         :null => false
    t.string   "street_1",                                          :null => false
    t.string   "street_2"
    t.string   "city",                                              :null => false
    t.string   "state",            :limit => 2,                     :null => false
    t.string   "zip",              :limit => 10,                    :null => false
    t.string   "phone",            :limit => 10
    t.boolean  "business_address",               :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",                         :null => false
    t.boolean  "selectable", :default => true, :null => false
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["ancestry"], :name => "index_categories_on_ancestry"
  add_index "categories", ["selectable"], :name => "index_categories_on_selectable"

  create_table "fans", :force => true do |t|
    t.integer  "user_id",       :null => false
    t.integer  "fannable_id",   :null => false
    t.string   "fannable_type", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fans", ["fannable_type", "fannable_id"], :name => "index_fans_on_fannable_type_and_fannable_id"
  add_index "fans", ["user_id"], :name => "index_fans_on_user_id"

  create_table "images", :force => true do |t|
    t.string   "attachable_type"
    t.integer  "attachable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "title"
  end

  create_table "item_comments", :force => true do |t|
    t.integer  "item_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_comments", ["item_id"], :name => "index_item_comments_on_item_id"

  create_table "items", :force => true do |t|
    t.string   "name",                                                                          :null => false
    t.decimal  "weight_lbs",                  :precision => 10, :scale => 0
    t.decimal  "price",                       :precision => 10, :scale => 0
    t.integer  "category_id",                                                                   :null => false
    t.integer  "user_id",                                                                       :null => false
    t.boolean  "swapped",                                                    :default => false, :null => false
    t.boolean  "available",                                                  :default => true,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "locker_id"
    t.integer  "team_id"
    t.integer  "hits",           :limit => 8,                                :default => 0,     :null => false
    t.datetime "last_hit"
    t.text     "description"
    t.string   "size"
    t.string   "shipping_price"
  end

  add_index "items", ["available"], :name => "index_items_on_available"
  add_index "items", ["category_id"], :name => "index_items_on_category_id"
  add_index "items", ["hits"], :name => "index_items_on_hits"
  add_index "items", ["last_hit", "hits"], :name => "index_items_on_last_hit_and_hits"
  add_index "items", ["locker_id"], :name => "index_items_on_locker_id"
  add_index "items", ["name"], :name => "index_items_on_name"
  add_index "items", ["price"], :name => "index_items_on_price"
  add_index "items", ["team_id"], :name => "index_items_on_team_id"
  add_index "items", ["user_id"], :name => "index_items_on_user_id"

  create_table "lockers", :force => true do |t|
    t.integer  "user_id",                                 :null => false
    t.string   "name",                                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hits",       :limit => 8, :default => 0,  :null => false
    t.datetime "last_hit"
    t.integer  "max_items",               :default => 15, :null => false
  end

  add_index "lockers", ["hits"], :name => "index_lockers_on_hits"
  add_index "lockers", ["last_hit", "hits"], :name => "index_lockers_on_last_hit_and_hits"
  add_index "lockers", ["name"], :name => "index_lockers_on_name"
  add_index "lockers", ["user_id"], :name => "index_lockers_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "to_user_id",                      :null => false
    t.integer  "from_user_id"
    t.boolean  "system",       :default => false, :null => false
    t.boolean  "unread",       :default => true,  :null => false
    t.string   "subject",                         :null => false
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["created_at"], :name => "index_messages_on_created_at"
  add_index "messages", ["to_user_id", "system"], :name => "index_messages_on_to_user_id_and_system"

  create_table "payments", :force => true do |t|
    t.integer  "swap_id",                                                               :null => false
    t.integer  "user_id"
    t.integer  "recipient_id",                                                          :null => false
    t.string   "paypal_correlation_id"
    t.string   "paypal_pay_key"
    t.string   "paypal_txn_id"
    t.string   "paypal_payment_status",                                                 :null => false
    t.decimal  "amt",                   :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.boolean  "successful",                                                            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "fee_amt",               :precision => 10, :scale => 2, :default => 0.0, :null => false
    t.text     "error_msg"
    t.integer  "error_id"
    t.string   "paypal_tracking_id"
  end

  add_index "payments", ["paypal_pay_key"], :name => "index_payments_on_paypal_pay_key"
  add_index "payments", ["paypal_payment_status"], :name => "index_payments_on_paypal_payment_status"
  add_index "payments", ["paypal_txn_id"], :name => "index_payments_on_paypal_txn_id"
  add_index "payments", ["recipient_id"], :name => "index_payments_on_recepient_id"
  add_index "payments", ["successful"], :name => "index_payments_on_successful"
  add_index "payments", ["swap_id"], :name => "index_payments_on_swap_id"
  add_index "payments", ["user_id"], :name => "index_payments_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "stores", :force => true do |t|
    t.string   "organizationname", :limit => 40
    t.string   "user_id",          :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "established_in"
    t.string   "gear_designed_by"
    t.string   "address_id"
    t.text     "cause"
  end

  create_table "swap_comments", :force => true do |t|
    t.integer  "swap_id",    :null => false
    t.integer  "user_id",    :null => false
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "swap_comments", ["swap_id"], :name => "index_swap_comments_on_swap_id"

  create_table "swap_item_feedbacks", :force => true do |t|
    t.integer  "user_id",      :null => false
    t.integer  "swap_item_id", :null => false
    t.integer  "rating",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "swap_item_feedbacks", ["swap_item_id"], :name => "index_swap_item_feedbacks_on_swap_item_id"
  add_index "swap_item_feedbacks", ["user_id"], :name => "index_swap_item_feedbacks_on_user_id"

  create_table "swap_items", :force => true do |t|
    t.integer  "swap_id",                     :null => false
    t.integer  "item_id",                     :null => false
    t.integer  "quantity",     :default => 1, :null => false
    t.integer  "recipient_id",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "swap_items", ["item_id"], :name => "index_swap_items_on_item_id"
  add_index "swap_items", ["recipient_id"], :name => "index_swap_items_on_recepient_id"
  add_index "swap_items", ["swap_id"], :name => "index_swap_items_on_swap_id"

  create_table "swap_parties", :force => true do |t|
    t.integer  "swap_id",                                                          :null => false
    t.integer  "user_id",                                                          :null => false
    t.integer  "response",                                          :default => 0, :null => false
    t.datetime "responded_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shipping_address_id",                                              :null => false
    t.decimal  "cash_offer",          :precision => 6, :scale => 2
    t.boolean  "confirm"
    t.text     "confirm_note"
  end

  add_index "swap_parties", ["confirm"], :name => "index_swap_parties_on_confirm"
  add_index "swap_parties", ["swap_id"], :name => "index_swap_parties_on_swap_id"
  add_index "swap_parties", ["user_id"], :name => "index_swap_parties_on_user_id"

  create_table "swaps", :force => true do |t|
    t.string   "name"
    t.boolean  "completed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "expiration",                    :null => false
    t.boolean  "agreed",     :default => false, :null => false
  end

  add_index "swaps", ["agreed"], :name => "index_swaps_on_agreed"
  add_index "swaps", ["expiration"], :name => "index_swaps_on_expiration"

  create_table "teams", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "city"
    t.string   "state"
    t.string   "country",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["country"], :name => "index_teams_on_country"
  add_index "teams", ["name"], :name => "index_teams_on_name"

  create_table "teams_user_profiles", :id => false, :force => true do |t|
    t.integer "user_profile_id", :null => false
    t.integer "team_id",         :null => false
  end

  add_index "teams_user_profiles", ["team_id", "user_profile_id"], :name => "index_teams_user_profiles_on_team_id_and_user_profile_id", :unique => true
  add_index "teams_user_profiles", ["user_profile_id"], :name => "index_teams_user_profiles_on_user_profile_id"

  create_table "user_profiles", :force => true do |t|
    t.integer  "user_id",        :null => false
    t.text     "bio"
    t.date     "birth_date"
    t.string   "gender"
    t.string   "location"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hometown"
    t.string   "schools"
    t.string   "club_teams"
    t.string   "sports"
    t.string   "favorite_teams"
    t.string   "favorite_brand"
  end

  add_index "user_profiles", ["birth_date"], :name => "index_user_profiles_on_birth_date"
  add_index "user_profiles", ["user_id"], :name => "index_user_profiles_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "first_name",                         :null => false
    t.string   "last_name",                          :null => false
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
    t.string   "paypal_email"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["role_id"], :name => "index_users_on_role_id"

end
