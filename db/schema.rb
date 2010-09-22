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

ActiveRecord::Schema.define(:version => 20100922102909) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "account_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "buy_finance_products", :force => true do |t|
    t.string   "name"
    t.decimal  "rate",        :precision => 10, :scale => 0
    t.integer  "account_id"
    t.date     "buy_date"
    t.date     "redeem_date"
    t.text     "description"
    t.decimal  "amount",      :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
  end

  create_table "cash_draw_items", :force => true do |t|
    t.integer  "sequence"
    t.string   "used_for"
    t.decimal  "apply_amount",       :precision => 10, :scale => 0
    t.integer  "inner_cash_draw_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cp_doc_details", :force => true do |t|
    t.integer  "sequence"
    t.date     "apply_date"
    t.integer  "dep_id"
    t.integer  "fee_id"
    t.integer  "project_id"
    t.string   "used_for"
    t.integer  "currency_id"
    t.decimal  "apply_amount", :precision => 10, :scale => 0
    t.decimal  "ori_amount",   :precision => 10, :scale => 0
    t.decimal  "rate",         :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
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
    t.integer  "doc_type"
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

  create_table "inner_cash_draws", :force => true do |t|
    t.integer  "account_id"
    t.decimal  "now_remain_amout", :precision => 10, :scale => 0
    t.text     "description"
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inner_remittances", :force => true do |t|
    t.integer  "out_account"
    t.string   "in_account_name"
    t.string   "in_account_no"
    t.decimal  "amount",          :precision => 10, :scale => 0
    t.text     "description"
    t.decimal  "remain_amount",   :precision => 10, :scale => 0
    t.decimal  "now_rate_price",  :precision => 10, :scale => 0
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inner_transfers", :force => true do |t|
    t.integer  "out_account"
    t.decimal  "out_amount_before", :precision => 10, :scale => 0
    t.decimal  "in_amount_before",  :precision => 10, :scale => 0
    t.decimal  "amount",            :precision => 10, :scale => 0
    t.text     "description"
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "in_account_name"
    t.string   "in_account_no"
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

  create_table "rd_benefits", :force => true do |t|
    t.integer  "sequence"
    t.date     "reim_date"
    t.integer  "fee_time_span"
    t.integer  "people_count"
    t.decimal  "amount",         :precision => 10, :scale => 0
    t.integer  "reim_detail_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rd_common_transports", :force => true do |t|
    t.string   "note"
    t.string   "start_place"
    t.string   "end_place"
    t.integer  "sequence"
    t.date     "work_date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "reason"
    t.integer  "reim_detail_id"
    t.decimal  "apply_amount",   :precision => 10, :scale => 0
    t.decimal  "hr_amount",      :precision => 10, :scale => 0
    t.decimal  "fi_amount",      :precision => 10, :scale => 0
    t.decimal  "final_amount",   :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rd_extra_work_cars", :force => true do |t|
    t.string   "start_place"
    t.string   "end_place"
    t.integer  "sequence"
    t.date     "work_date"
    t.integer  "is_sunday"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "reason"
    t.integer  "reim_detail_id"
    t.decimal  "apply_amount",   :precision => 10, :scale => 0
    t.decimal  "hr_amount",      :precision => 10, :scale => 0
    t.decimal  "fi_amount",      :precision => 10, :scale => 0
    t.decimal  "final_amount",   :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rd_extra_work_meals", :force => true do |t|
    t.integer  "sequence"
    t.date     "work_date"
    t.integer  "is_sunday"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "reason"
    t.integer  "reim_detail_id"
    t.decimal  "apply_amount",   :precision => 10, :scale => 0
    t.decimal  "hr_amount",      :precision => 10, :scale => 0
    t.decimal  "fi_amount",      :precision => 10, :scale => 0
    t.decimal  "final_amount",   :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rd_lodgings", :force => true do |t|
    t.integer  "sequence"
    t.integer  "reim_detail_id"
    t.integer  "region_id"
    t.date     "lodging_date"
    t.integer  "days"
    t.integer  "people_count"
    t.string   "person_names"
    t.decimal  "apply_amount",   :precision => 10, :scale => 0
    t.decimal  "hr_amount",      :precision => 10, :scale => 0
    t.decimal  "fi_amount",      :precision => 10, :scale => 0
    t.decimal  "final_amount",   :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rd_transports", :force => true do |t|
    t.integer  "sequence"
    t.integer  "reim_detail_id"
    t.time     "start_date"
    t.time     "end_date"
    t.string   "start_position"
    t.string   "end_position"
    t.integer  "transportation_id"
    t.string   "reason"
    t.decimal  "apply_amount",      :precision => 10, :scale => 0
    t.decimal  "hr_amount",         :precision => 10, :scale => 0
    t.decimal  "fi_amount",         :precision => 10, :scale => 0
    t.decimal  "final_amount",      :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rd_travels", :force => true do |t|
    t.integer  "sequence"
    t.integer  "days"
    t.integer  "region_id"
    t.string   "reason"
    t.integer  "fee_standard_id"
    t.string   "other_fee"
    t.string   "other_fee_description"
    t.decimal  "apply_amount",          :precision => 10, :scale => 0
    t.decimal  "hr_amount",             :precision => 10, :scale => 0
    t.decimal  "fi_amount",             :precision => 10, :scale => 0
    t.decimal  "final_amount",          :precision => 10, :scale => 0
    t.integer  "reim_detail_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rd_work_meals", :force => true do |t|
    t.integer  "sequence"
    t.date     "meal_date"
    t.string   "place"
    t.integer  "people_count"
    t.string   "person_names"
    t.string   "reason"
    t.integer  "reim_detail_id"
    t.decimal  "apply_amount",   :precision => 10, :scale => 0
    t.decimal  "hr_amount",      :precision => 10, :scale => 0
    t.decimal  "fi_amount",      :precision => 10, :scale => 0
    t.decimal  "final_amount",   :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rec_notice_details", :force => true do |t|
    t.integer  "sequence"
    t.date     "apply_date"
    t.string   "company"
    t.integer  "dep_id"
    t.integer  "project_id"
    t.string   "description"
    t.decimal  "amount",      :precision => 10, :scale => 0
    t.integer  "currency_id"
    t.decimal  "ori_amount",  :precision => 10, :scale => 0
    t.decimal  "rate",        :precision => 10, :scale => 0
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recivers", :force => true do |t|
    t.integer  "sequence"
    t.integer  "settlement_id"
    t.string   "company"
    t.string   "bank"
    t.string   "bank_no"
    t.decimal  "amount",        :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
  end

  create_table "redeem_finance_products", :force => true do |t|
    t.string   "name"
    t.decimal  "rate",        :precision => 10, :scale => 0
    t.integer  "account_id"
    t.date     "clear_date"
    t.date     "redeem_date"
    t.text     "description"
    t.decimal  "amount",      :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reim_details", :force => true do |t|
    t.integer  "sequence"
    t.integer  "fee_id"
    t.integer  "dep_id"
    t.integer  "project_id"
    t.string   "description"
    t.decimal  "amount",      :precision => 10, :scale => 0
    t.integer  "currency_id"
    t.decimal  "ori_amount",  :precision => 10, :scale => 0
    t.decimal  "rate",        :precision => 10, :scale => 0
    t.decimal  "real_amount", :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
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
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_user_name", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "work_flow_steps", :force => true do |t|
    t.integer  "dep_id"
    t.integer  "is_self_dep"
    t.integer  "duty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "work_flow_id"
  end

  create_table "work_flows", :force => true do |t|
    t.string   "name"
    t.string   "doc_types"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
