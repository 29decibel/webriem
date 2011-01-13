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

ActiveRecord::Schema.define(:version => 20110113132417) do

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
    t.decimal  "jan",        :precision => 16, :scale => 2
    t.decimal  "feb",        :precision => 16, :scale => 2
    t.decimal  "mar",        :precision => 16, :scale => 2
    t.decimal  "apr",        :precision => 16, :scale => 2
    t.decimal  "may",        :precision => 16, :scale => 2
    t.decimal  "jun",        :precision => 16, :scale => 2
    t.decimal  "jul",        :precision => 16, :scale => 2
    t.decimal  "aug",        :precision => 16, :scale => 2
    t.decimal  "sep",        :precision => 16, :scale => 2
    t.decimal  "oct",        :precision => 16, :scale => 2
    t.decimal  "nov",        :precision => 16, :scale => 2
    t.decimal  "dec",        :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
  end

  create_table "business_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buy_finance_products", :force => true do |t|
    t.string   "name"
    t.decimal  "rate",        :precision => 14, :scale => 4
    t.integer  "account_id"
    t.date     "buy_date"
    t.date     "redeem_date"
    t.text     "description"
    t.decimal  "amount",      :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
  end

  create_table "cash_draw_items", :force => true do |t|
    t.integer  "sequence"
    t.string   "used_for"
    t.decimal  "apply_amount",       :precision => 16, :scale => 2
    t.integer  "inner_cash_draw_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "common_riems", :force => true do |t|
    t.integer  "sequence"
    t.integer  "fee_id"
    t.integer  "dep_id"
    t.integer  "project_id"
    t.string   "description"
    t.integer  "currency_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2
    t.decimal  "rate",         :precision => 14, :scale => 4
    t.decimal  "ori_amount",   :precision => 16, :scale => 2
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "config_helpers", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cp_doc_details", :force => true do |t|
    t.integer  "sequence"
    t.integer  "dep_id"
    t.integer  "fee_id"
    t.integer  "project_id"
    t.string   "used_for"
    t.integer  "currency_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2
    t.decimal  "ori_amount",   :precision => 16, :scale => 2
    t.decimal  "rate",         :precision => 14, :scale => 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
  end

  create_table "currencies", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "default_rate", :precision => 10, :scale => 4
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

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
    t.string   "doc_no"
    t.integer  "attach"
    t.integer  "person_id"
    t.string   "note"
    t.date     "apply_date"
    t.integer  "dep_id"
    t.integer  "fee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_type"
    t.integer  "doc_state"
    t.integer  "work_flow_step_id"
    t.integer  "project_id"
    t.integer  "is_split"
    t.decimal  "cp_doc_remain_amount", :precision => 16, :scale => 2
    t.integer  "selected_approver_id"
    t.integer  "afford_dep_id"
    t.integer  "upload_file_id"
    t.decimal  "total_amount",         :precision => 16, :scale => 2
    t.integer  "real_person_id"
    t.integer  "current_approver_id"
    t.string   "approvers"
    t.string   "mark"
  end

  create_table "duties", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "duties_work_flows", :id => false, :force => true do |t|
    t.integer  "work_flow_id"
    t.integer  "duty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extra_work_standards", :force => true do |t|
    t.time     "late_than_time"
    t.boolean  "is_sunday",                                     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "amount",         :precision => 16, :scale => 2
    t.integer  "fee_id"
  end

  create_table "extra_work_types", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fee_standards", :force => true do |t|
    t.integer  "project_id"
    t.integer  "duty_id"
    t.integer  "lodging_id"
    t.integer  "transportation_id"
    t.decimal  "amount",            :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "business_type_id"
    t.integer  "region_type_id"
    t.integer  "currency_id"
    t.integer  "fee_id"
    t.integer  "person_type_id"
  end

  create_table "feed_backs", :force => true do |t|
    t.text     "content"
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
    t.decimal  "now_remain_amout", :precision => 16, :scale => 2
    t.text     "description"
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inner_remittances", :force => true do |t|
    t.integer  "out_account_id"
    t.decimal  "amount",          :precision => 16, :scale => 2
    t.text     "description"
    t.decimal  "remain_amount",   :precision => 16, :scale => 2
    t.decimal  "now_rate_price",  :precision => 14, :scale => 4
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "currency_id"
    t.integer  "in_account_id"
    t.decimal  "in_amount_after", :precision => 16, :scale => 2
  end

  create_table "inner_transfers", :force => true do |t|
    t.integer  "out_account_id"
    t.decimal  "out_amount_before", :precision => 16, :scale => 2
    t.decimal  "in_amount_before",  :precision => 16, :scale => 2
    t.decimal  "amount",            :precision => 16, :scale => 2
    t.text     "description"
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "in_account_id"
    t.decimal  "in_amount_after",   :precision => 16, :scale => 2
  end

  create_table "lodgings", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_rights", :force => true do |t|
    t.integer  "role_id"
    t.integer  "menu_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "menu_type"
  end

  create_table "other_riems", :force => true do |t|
    t.integer  "sequence"
    t.string   "description"
    t.integer  "currency_id"
    t.decimal  "rate",         :precision => 10, :scale => 4
    t.integer  "doc_head_id"
    t.decimal  "ori_amount",   :precision => 16, :scale => 2
    t.decimal  "apply_amount", :precision => 16, :scale => 2
    t.decimal  "hr_amount",    :precision => 16, :scale => 2
    t.decimal  "fi_amount",    :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "gender"
    t.integer  "dep_id"
    t.integer  "duty_id"
    t.string   "phone"
    t.string   "e_mail"
    t.string   "ID_card"
    t.string   "bank_no"
    t.string   "bank"
    t.date     "end_date"
    t.integer  "credit_limit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
    t.integer  "person_type_id"
  end

  create_table "person_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "u8_project"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
  end

  create_table "rd_benefits", :force => true do |t|
    t.integer  "sequence"
    t.date     "reim_date"
    t.integer  "fee_time_span"
    t.integer  "people_count"
    t.decimal  "apply_amount",  :precision => 16, :scale => 2
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "hr_amount",     :precision => 16, :scale => 2
    t.decimal  "fi_amount",     :precision => 16, :scale => 2
    t.integer  "dep_id"
    t.integer  "fee_id"
    t.integer  "project_id"
  end

  create_table "rd_common_transports", :force => true do |t|
    t.string   "start_place"
    t.string   "end_place"
    t.integer  "sequence"
    t.date     "work_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "reason"
    t.integer  "doc_head_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",         :precision => 14, :scale => 4
    t.integer  "currency_id"
    t.decimal  "ori_amount",   :precision => 16, :scale => 2
    t.integer  "dep_id"
    t.integer  "project_id"
  end

  create_table "rd_extra_work_cars", :force => true do |t|
    t.string   "start_place"
    t.string   "end_place"
    t.integer  "sequence"
    t.date     "work_date"
    t.integer  "is_sunday"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "reason"
    t.integer  "doc_head_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2
    t.decimal  "hr_amount",    :precision => 16, :scale => 2
    t.decimal  "fi_amount",    :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",         :precision => 14, :scale => 4
    t.integer  "currency_id"
    t.decimal  "ori_amount",   :precision => 16, :scale => 2
  end

  create_table "rd_extra_work_meals", :force => true do |t|
    t.integer  "sequence"
    t.date     "work_date"
    t.integer  "is_sunday"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "reason"
    t.integer  "doc_head_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2
    t.decimal  "hr_amount",    :precision => 16, :scale => 2
    t.decimal  "fi_amount",    :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",         :precision => 14, :scale => 4
    t.integer  "currency_id"
    t.decimal  "ori_amount",   :precision => 16, :scale => 2
    t.decimal  "st_amount",    :precision => 8,  :scale => 2
  end

  create_table "rd_lodgings", :force => true do |t|
    t.integer  "sequence"
    t.integer  "doc_head_id"
    t.integer  "region_id"
    t.integer  "days"
    t.integer  "people_count"
    t.string   "person_names"
    t.decimal  "apply_amount",   :precision => 16, :scale => 2
    t.decimal  "hr_amount",      :precision => 16, :scale => 2
    t.decimal  "fi_amount",      :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",           :precision => 14, :scale => 4
    t.integer  "currency_id"
    t.decimal  "ori_amount",     :precision => 16, :scale => 2
    t.string   "custom_place"
    t.integer  "region_type_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.decimal  "st_amount",      :precision => 8,  :scale => 2
  end

  create_table "rd_transports", :force => true do |t|
    t.integer  "sequence"
    t.integer  "doc_head_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "start_position"
    t.string   "end_position"
    t.integer  "transportation_id"
    t.string   "reason"
    t.decimal  "apply_amount",      :precision => 16, :scale => 2
    t.decimal  "hr_amount",         :precision => 16, :scale => 2
    t.decimal  "fi_amount",         :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",              :precision => 14, :scale => 4
    t.integer  "currency_id"
    t.decimal  "ori_amount",        :precision => 16, :scale => 2
  end

  create_table "rd_travels", :force => true do |t|
    t.integer  "sequence"
    t.decimal  "days",                  :precision => 8,  :scale => 2
    t.integer  "region_id"
    t.string   "reason"
    t.string   "other_fee"
    t.string   "other_fee_description"
    t.decimal  "apply_amount",          :precision => 16, :scale => 2
    t.decimal  "hr_amount",             :precision => 16, :scale => 2
    t.decimal  "fi_amount",             :precision => 16, :scale => 2
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",                  :precision => 14, :scale => 4
    t.integer  "currency_id"
    t.decimal  "ori_amount",            :precision => 16, :scale => 2
    t.string   "custom_place"
    t.integer  "region_type_id"
    t.decimal  "st_amount",             :precision => 8,  :scale => 2
  end

  create_table "rd_work_meals", :force => true do |t|
    t.integer  "sequence"
    t.date     "meal_date"
    t.string   "place"
    t.integer  "people_count"
    t.string   "person_names"
    t.string   "reason"
    t.integer  "doc_head_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",         :precision => 14, :scale => 4
    t.integer  "currency_id"
    t.decimal  "ori_amount",   :precision => 16, :scale => 2
    t.integer  "dep_id"
    t.integer  "project_id"
  end

  create_table "rec_notice_details", :force => true do |t|
    t.integer  "sequence"
    t.date     "apply_date"
    t.string   "company"
    t.integer  "dep_id"
    t.integer  "project_id"
    t.string   "description"
    t.decimal  "amount",      :precision => 16, :scale => 2
    t.integer  "currency_id"
    t.decimal  "ori_amount",  :precision => 16, :scale => 2
    t.decimal  "rate",        :precision => 14, :scale => 4
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
    t.decimal  "amount",        :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
    t.decimal  "hr_amount",     :precision => 16, :scale => 2
    t.decimal  "fi_amount",     :precision => 16, :scale => 2
  end

  create_table "redeem_finance_products", :force => true do |t|
    t.string   "name"
    t.decimal  "rate",        :precision => 14, :scale => 4
    t.integer  "account_id"
    t.date     "clear_date"
    t.date     "redeem_date"
    t.text     "description"
    t.decimal  "amount",      :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
  end

  create_table "region_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
  end

  create_table "regions", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_type_id"
  end

  create_table "reim_details", :force => true do |t|
    t.integer  "sequence"
    t.integer  "fee_id"
    t.integer  "dep_id"
    t.integer  "project_id"
    t.string   "description"
    t.decimal  "amount",      :precision => 16, :scale => 2
    t.integer  "currency_id"
    t.decimal  "ori_amount",  :precision => 16, :scale => 2
    t.decimal  "rate",        :precision => 14, :scale => 4
    t.decimal  "real_amount", :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
    t.integer  "is_split"
  end

  create_table "reim_split_details", :force => true do |t|
    t.integer  "doc_head_id"
    t.integer  "dep_id"
    t.integer  "project_id"
    t.integer  "fee_id"
    t.decimal  "percent",        :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sequence"
    t.decimal  "percent_amount", :precision => 8, :scale => 2
  end

  create_table "riem_cp_offsets", :force => true do |t|
    t.integer  "reim_doc_head_id"
    t.integer  "cp_doc_head_id"
    t.decimal  "amount",           :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "settlements", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "subject"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", :force => true do |t|
    t.integer  "fee_id"
    t.integer  "dep_id"
    t.string   "u8_fee_subject"
    t.string   "u8_borrow_subject"
    t.string   "u8_reim_subject"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "business_type_id"
  end

  create_table "transportations", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "upload_files", :force => true do |t|
    t.integer  "p_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "upload_file_name"
    t.string   "upload_content_type"
    t.integer  "upload_file_size"
    t.datetime "upload_updated_at"
    t.string   "doc_no"
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

  create_table "work_flow_duties", :force => true do |t|
    t.integer  "work_flow_id"
    t.integer  "duty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_flow_infos", :force => true do |t|
    t.integer  "doc_head_id"
    t.integer  "is_ok"
    t.integer  "people_id"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_flow_steps", :force => true do |t|
    t.integer  "dep_id"
    t.integer  "is_self_dep"
    t.integer  "duty_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "work_flow_id"
    t.decimal  "max_amount",   :precision => 8, :scale => 2
  end

  create_table "work_flows", :force => true do |t|
    t.string   "name"
    t.string   "doc_types"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
