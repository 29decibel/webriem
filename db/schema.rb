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

ActiveRecord::Schema.define(:version => 20100911054037) do

  create_table "budgets", :force => true do |t|
    t.integer  "fee_id"
    t.integer  "project_id"
    t.integer  "dep_id"
    t.decimal  "jan",        :precision => 10, :scale => 0
    t.decimal  "feb",        :precision => 10, :scale => 0
    t.decimal  "mar",        :precision => 10, :scale => 0
    t.decimal  "apr",        :precision => 10, :scale => 0
    t.decimal  "may",        :precision => 10, :scale => 0
    t.decimal  "jun",        :precision => 10, :scale => 0
    t.decimal  "jul",        :precision => 10, :scale => 0
    t.decimal  "aug",        :precision => 10, :scale => 0
    t.decimal  "sep",        :precision => 10, :scale => 0
    t.decimal  "oct",        :precision => 10, :scale => 0
    t.decimal  "nov",        :precision => 10, :scale => 0
    t.decimal  "dec",        :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "currencies", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deps", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "version"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "u8dep_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_dep_id"
  end

  create_table "doc_heads", :force => true do |t|
    t.integer  "doc_no"
    t.integer  "attach"
    t.integer  "person_id"
    t.string   "note"
    t.date     "apply_date"
    t.integer  "dep_id"
    t.integer  "fee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "duties", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fee_standards", :force => true do |t|
    t.integer  "project_id"
    t.integer  "region_id"
    t.integer  "duty_id"
    t.integer  "lodging_id"
    t.integer  "transportation_id"
    t.integer  "busitype"
    t.decimal  "amount",            :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fees", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "attr"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_fee_id"
  end

  create_table "lodgings", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "gender"
    t.integer  "dep_id"
    t.integer  "duty_id"
    t.integer  "boss_id"
    t.string   "phone"
    t.string   "e_mail"
    t.string   "ID_card"
    t.string   "bank_no"
    t.string   "bank"
    t.date     "end_date"
    t.integer  "credit_limit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "u8_project"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settlements", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", :force => true do |t|
    t.integer  "busitype"
    t.integer  "fee_id"
    t.integer  "dep_id"
    t.string   "u8_fee_subject"
    t.string   "u8_borrow_subject"
    t.string   "u8_reim_subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transportations", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["user_name"], :name => "index_users_on_user_name", :unique => true

end
