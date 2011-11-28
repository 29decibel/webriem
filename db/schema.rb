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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111128101807) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.string   "account_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["name"], :name => "index_accounts_on_name"

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
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

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "borrow_doc_details", :force => true do |t|
    t.integer  "sequence"
    t.integer  "dep_id"
    t.integer  "fee_id"
    t.integer  "project_id"
    t.string   "used_for"
    t.integer  "currency_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2, :default => 0
    t.decimal  "ori_amount",   :precision => 16, :scale => 2, :default => 0
    t.decimal  "rate",         :precision => 14, :scale => 4, :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
  end

  add_index "borrow_doc_details", ["dep_id"], :name => "index_borrow_doc_details_on_dep_id"
  add_index "borrow_doc_details", ["doc_head_id"], :name => "index_borrow_doc_details_on_doc_head_id"
  add_index "borrow_doc_details", ["fee_id"], :name => "index_borrow_doc_details_on_fee_id"
  add_index "borrow_doc_details", ["project_id"], :name => "index_borrow_doc_details_on_project_id"

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

  add_index "budgets", ["dep_id"], :name => "index_budgets_on_dep_id"
  add_index "budgets", ["fee_id"], :name => "index_budgets_on_fee_id"
  add_index "budgets", ["project_id"], :name => "index_budgets_on_project_id"

  create_table "business_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buy_finance_products", :force => true do |t|
    t.string   "name"
    t.decimal  "rate",        :precision => 14, :scale => 4, :default=>1
    t.integer  "account_id"
    t.date     "buy_date"
    t.date     "redeem_date"
    t.text     "description"
    t.decimal  "amount",      :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
  end

  add_index "buy_finance_products", ["account_id"], :name => "index_buy_finance_products_on_account_id"
  add_index "buy_finance_products", ["doc_head_id"], :name => "index_buy_finance_products_on_doc_head_id"

  create_table "cash_draw_items", :force => true do |t|
    t.integer  "sequence"
    t.string   "used_for"
    t.decimal  "apply_amount",       :precision => 16, :scale => 2
    t.integer  "inner_cash_draw_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cash_draw_items", ["inner_cash_draw_id"], :name => "index_cash_draw_items_on_inner_cash_draw_id"

  create_table "common_riems", :force => true do |t|
    t.integer  "sequence"
    t.integer  "fee_id"
    t.integer  "dep_id"
    t.integer  "project_id"
    t.string   "description"
    t.integer  "currency_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2, :default => 0
    t.decimal  "rate",         :precision => 14, :scale => 4, :default=>1
    t.decimal  "ori_amount",   :precision => 16, :scale => 2, :default => 0
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "common_riems", ["dep_id"], :name => "index_common_riems_on_dep_id"
  add_index "common_riems", ["doc_head_id"], :name => "index_common_riems_on_doc_head_id"
  add_index "common_riems", ["fee_id"], :name => "index_common_riems_on_fee_id"
  add_index "common_riems", ["project_id"], :name => "index_common_riems_on_project_id"

  create_table "company_groups", :force => true do |t|
    t.string   "name"
    t.string   "code"
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
    t.decimal  "ori_amount",  :precision => 16, :scale => 2, :default => 0
    t.decimal  "rate",        :precision => 14, :scale => 4, :default=>1
    t.decimal  "apply_amount", :precision => 16, :scale => 2, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
    t.decimal  "rate_amount", :precision => 16, :scale => 2
  end

  add_index "cp_doc_details", ["dep_id"], :name => "index_cp_doc_details_on_dep_id"
  add_index "cp_doc_details", ["doc_head_id"], :name => "index_cp_doc_details_on_doc_head_id"
  add_index "cp_doc_details", ["fee_id"], :name => "index_cp_doc_details_on_fee_id"
  add_index "cp_doc_details", ["project_id"], :name => "index_cp_doc_details_on_project_id"

  create_table "currencies", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "default_rate", :precision => 10, :scale => 4
  end

  add_index "currencies", ["code"], :name => "index_currencies_on_code"
  add_index "currencies", ["name"], :name => "index_currencies_on_name"

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

  create_table "demo_customers", :force => true do |t|
    t.string   "email"
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
    t.integer  "u8_dep_id"
    t.integer  "status"
  end

  add_index "deps", ["code"], :name => "index_deps_on_code"
  add_index "deps", ["name"], :name => "index_deps_on_name"

  create_table "doc_heads", :force => true do |t|
    t.string   "doc_no"
    t.integer  "attach"
    t.integer  "person_id"
    t.string   "note"
    t.date     "apply_date"
    t.integer  "dep_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
    t.decimal  "cp_doc_remain_amount", :precision => 16, :scale => 2
    t.integer  "afford_dep_id"
    t.integer  "upload_file_id"
    t.decimal  "total_amount",         :precision => 16, :scale => 2
    t.integer  "real_person_id"
    t.integer  "current_approver_id"
    t.integer  "current_approver_info_id"
    t.string   "mark"
    t.string   "state"
    t.integer  "company_group_id"
    t.integer  "doc_state"
    t.integer  "doc_meta_info_id"
  end

  add_index "doc_heads", ["afford_dep_id"], :name => "index_doc_heads_on_afford_dep_id"
  add_index "doc_heads", ["dep_id"], :name => "index_doc_heads_on_dep_id"
  add_index "doc_heads", ["mark"], :name => "index_doc_heads_on_mark"
  add_index "doc_heads", ["person_id"], :name => "index_doc_heads_on_person_id"
  add_index "doc_heads", ["project_id"], :name => "index_doc_heads_on_project_id"
  add_index "doc_heads", ["real_person_id"], :name => "index_doc_heads_on_real_person_id"
  add_index "doc_heads", ["state"], :name => "index_doc_heads_on_doc_state"


  create_table :contract_docs,:force => true do |t|
    t.integer 'doc_head_id'
    t.string  'channel'
    t.string  "district"
    t.string  'customer'
    t.string  'work_phone'
    t.string  'contact_person'
    t.string  'duty'
    t.string  'cellphone'
    t.string  'email'
    t.date    'bill_date'
    t.string  :source
    t.string  'bill_name'
    t.string  'bill_amount'
    t.string  'contract_info'
    t.decimal 'product_price',         :precision => 16, :scale => 2
    t.string  'agent'
    t.string  'agent_phone'
    t.string  'agent_contact_name'
    t.string  'agent_contact_duty'
    t.string  'agent_contact_phone'
    t.string  'agent_contact_email'
    t.string  'ip_address'
    t.string  'pay_info'
    t.string  'buy_info'
    t.string  'deploy_info'
    t.string  'project_info'
  end

  create_table "doc_meta_infos", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "display_name"
    t.string   "doc_head_attrs"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table :doc_relations do |t|
      t.integer :doc_meta_info_id
      t.boolean :multiple
      t.integer :doc_row_meta_info_id
      t.string  :doc_row_attrs

      t.timestamps
  end
  

  create_table "doc_meta_infos_work_flows", :id => false, :force => true do |t|
    t.integer "work_flow_id"
    t.integer "doc_meta_info_id"
  end

  create_table "doc_row_meta_infos", :force => true do |t|
    t.string   "name"
    t.string   "display_name"
    t.integer  "fee_id"
    t.string   "read_only_attrs"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table :fee_rules do |t|
    t.integer :priority ,:default => 1
    t.string :factors
    t.integer :fee_id
    t.decimal :amount,         :precision => 16, :scale => 2

    t.timestamps
  end

  create_table :doc_amount_changes do |t|
    t.string :resource_class
    t.integer :resource_id
    t.decimal :new_amount,         :precision => 16, :scale => 2
    t.integer :person_id
    t.integer :doc_head_id

    t.timestamps
  end

  create_table "doc_rows", :force => true do |t|
    t.integer  "doc_head_id"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.integer  "dep_id"
    t.integer  "project_id"
    t.decimal  "apply_amount",     :precision => 16, :scale => 2
    t.decimal  "doc_total_amount", :precision => 16, :scale => 2
    t.decimal  "changed_amount", :precision => 16, :scale => 2
    t.integer  "fee_id"
    t.integer  "person_id"
    t.integer  "person_dep_id"
    t.date     "apply_date"
    t.string   "doc_no"
    t.string   "doc_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "doc_rows", ["apply_amount"], :name => "index_doc_rows_on_apply_amount"
  add_index "doc_rows", ["apply_date"], :name => "index_doc_rows_on_apply_date"
  add_index "doc_rows", ["dep_id"], :name => "index_doc_rows_on_dep_id"
  add_index "doc_rows", ["doc_no"], :name => "index_doc_rows_on_doc_no"
  add_index "doc_rows", ["doc_state"], :name => "index_doc_rows_on_doc_state"
  add_index "doc_rows", ["doc_total_amount"], :name => "index_doc_rows_on_doc_total_amount"
  add_index "doc_rows", ["fee_id"], :name => "index_doc_rows_on_fee_id"
  add_index "doc_rows", ["person_dep_id"], :name => "index_doc_rows_on_person_dep_id"
  add_index "doc_rows", ["person_id"], :name => "index_doc_rows_on_person_id"
  add_index "doc_rows", ["project_id"], :name => "index_doc_rows_on_project_id"

  create_table "duties", :force => true do |t|
    t.string   "name"
    t.string   "code"
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

  create_table "fee_code_matches", :force => true do |t|
    t.integer  "fee_id"
    t.integer  "dcode_id"
    t.integer  "ccode_id"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fee_code"
    t.string   "dperson"
    t.string   "ddep"
    t.string   "cperson"
    t.string   "cdep"
  end

  add_index "fee_code_matches", ["ccode_id"], :name => "index_fee_code_matches_on_ccode_id"
  add_index "fee_code_matches", ["dcode_id"], :name => "index_fee_code_matches_on_dcode_id"
  add_index "fee_code_matches", ["fee_id"], :name => "index_fee_code_matches_on_fee_id"

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

  add_index "fee_standards", ["business_type_id"], :name => "index_fee_standards_on_business_type_id"
  add_index "fee_standards", ["currency_id"], :name => "index_fee_standards_on_currency_id"
  add_index "fee_standards", ["duty_id"], :name => "index_fee_standards_on_duty_id"
  add_index "fee_standards", ["fee_id"], :name => "index_fee_standards_on_fee_id"
  add_index "fee_standards", ["lodging_id"], :name => "index_fee_standards_on_lodging_id"
  add_index "fee_standards", ["person_type_id"], :name => "index_fee_standards_on_person_type_id"
  add_index "fee_standards", ["project_id"], :name => "index_fee_standards_on_project_id"
  add_index "fee_standards", ["region_type_id"], :name => "index_fee_standards_on_region_type_id"
  add_index "fee_standards", ["transportation_id"], :name => "index_fee_standards_on_transportation_id"

  create_table "feed_backs", :force => true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fees", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_fee_id"
    t.string   "fee_type"
  end

  add_index "fees", ["code"], :name => "index_fees_on_code"
  add_index "fees", ["name"], :name => "index_fees_on_name"

  create_table "lodgings", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lodgings", ["code"], :name => "index_lodgings_on_code"
  add_index "lodgings", ["name"], :name => "index_lodgings_on_name"


  create_table "menus", :force => true do |t|
    t.string   "name"
    t.string   "path"
    t.string   "group_name"
    t.integer  "priority",:default =>1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus_roles", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "menu_id"
  end

  create_table "other_riems", :force => true do |t|
    t.integer  "sequence"
    t.string   "description"
    t.integer  "currency_id"
    t.decimal  "rate",         :precision => 10, :scale => 4, :default=>1
    t.integer  "doc_head_id"
    t.decimal  "ori_amount",   :precision => 16, :scale => 2, :default => 0
    t.decimal  "apply_amount", :precision => 16, :scale => 2, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "other_riems", ["currency_id"], :name => "index_other_riems_on_currency_id"
  add_index "other_riems", ["doc_head_id"], :name => "index_other_riems_on_doc_head_id"

  create_table "pay_doc_details", :force => true do |t|
    t.integer  "sequence"
    t.integer  "dep_id"
    t.integer  "fee_id"
    t.integer  "project_id"
    t.string   "used_for"
    t.integer  "currency_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2, :default => 0
    t.decimal  "ori_amount",   :precision => 16, :scale => 2, :default => 0
    t.decimal  "rate",         :precision => 14, :scale => 4, :default=>1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
  end

  add_index "pay_doc_details", ["dep_id"], :name => "index_pay_doc_details_on_dep_id"
  add_index "pay_doc_details", ["doc_head_id"], :name => "index_pay_doc_details_on_doc_head_id"
  add_index "pay_doc_details", ["fee_id"], :name => "index_pay_doc_details_on_fee_id"
  add_index "pay_doc_details", ["project_id"], :name => "index_pay_doc_details_on_project_id"

  create_table "people", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "gender"
    t.integer  "dep_id"
    t.integer  "duty_id"
    t.string   "phone"
    t.string   "e_mail"
    t.string   "ID_card"
    t.string   "bank_no"
    t.string   "bank"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "birthday"
    t.integer  "credit_limit"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id"
    t.integer  "person_type_id"
    t.string   "employ_category"
    t.string   "duty_level"
    t.string   "duty_category"
    t.string   "duty_name"
    t.string   "factors"
  end

  add_index "people", ["code"], :name => "index_people_on_code"
  add_index "people", ["dep_id"], :name => "index_people_on_dep_id"
  add_index "people", ["duty_id"], :name => "index_people_on_duty_id"
  add_index "people", ["name"], :name => "index_people_on_name"
  add_index "people", ["person_type_id"], :name => "index_people_on_person_type_id"
  add_index "people", ["role_id"], :name => "index_people_on_role_id"

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
    t.string   "status"
    t.integer  "dep_id"
  end

  add_index "projects", ["code"], :name => "index_projects_on_code"
  add_index "projects", ["name"], :name => "index_projects_on_name"

  create_table "property_types", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories_on_item_and_table_and_month_and_year"

  create_table "rd_benefits", :force => true do |t|
    t.integer  "sequence"
    t.date     "reim_date"
    t.integer  "fee_time_span"
    t.integer  "people_count"
    t.decimal  "apply_amount",  :precision => 16, :scale => 2, :default => 0
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dep_id"
    t.integer  "fee_id"
    t.integer  "project_id"
    t.decimal  "rate",          :precision => 10, :scale => 4, :default => 1.0
    t.integer  "currency_id"
    t.decimal  "ori_amount",    :precision => 16, :scale => 2, :default => 0
  end

  add_index "rd_benefits", ["dep_id"], :name => "index_rd_benefits_on_dep_id"
  add_index "rd_benefits", ["doc_head_id"], :name => "index_rd_benefits_on_doc_head_id"
  add_index "rd_benefits", ["fee_id"], :name => "index_rd_benefits_on_fee_id"
  add_index "rd_benefits", ["project_id"], :name => "index_rd_benefits_on_project_id"

  create_table "rd_common_transports", :force => true do |t|
    t.string   "start_place"
    t.string   "end_place"
    t.integer  "sequence"
    t.date     "work_date"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "reason"
    t.integer  "doc_head_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",         :precision => 14, :scale => 4, :default=>1
    t.integer  "currency_id"
    t.decimal  "ori_amount",   :precision => 16, :scale => 2, :default => 0
    t.integer  "dep_id"
    t.integer  "project_id"
  end

  add_index "rd_common_transports", ["currency_id"], :name => "index_rd_common_transports_on_currency_id"
  add_index "rd_common_transports", ["dep_id"], :name => "index_rd_common_transports_on_dep_id"
  add_index "rd_common_transports", ["doc_head_id"], :name => "index_rd_common_transports_on_doc_head_id"
  add_index "rd_common_transports", ["project_id"], :name => "index_rd_common_transports_on_project_id"

  create_table "rd_communicates", :force => true do |t|
    t.integer  "sequence"
    t.date     "meal_date"
    t.string   "place"
    t.integer  "people_count"
    t.string   "person_names"
    t.string   "reason"
    t.integer  "doc_head_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",         :precision => 14, :scale => 4, :default=>1
    t.integer  "currency_id"
    t.decimal  "ori_amount",   :precision => 16, :scale => 2, :default => 0
    t.integer  "dep_id"
    t.integer  "project_id"
  end

  add_index "rd_communicates", ["currency_id"], :name => "index_rd_communicates_on_currency_id"
  add_index "rd_communicates", ["dep_id"], :name => "index_rd_communicates_on_dep_id"
  add_index "rd_communicates", ["doc_head_id"], :name => "index_rd_communicates_on_doc_head_id"
  add_index "rd_communicates", ["project_id"], :name => "index_rd_communicates_on_project_id"

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
    t.decimal  "apply_amount", :precision => 16, :scale => 2, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",         :precision => 14, :scale => 4, :default=>1
    t.integer  "currency_id"
    t.decimal  "ori_amount",   :precision => 16, :scale => 2, :default => 0
  end

  add_index "rd_extra_work_cars", ["currency_id"], :name => "index_rd_extra_work_cars_on_currency_id"
  add_index "rd_extra_work_cars", ["doc_head_id"], :name => "index_rd_extra_work_cars_on_doc_head_id"

  create_table "rd_extra_work_meals", :force => true do |t|
    t.integer  "sequence"
    t.date     "work_date"
    t.integer  "is_sunday"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "reason"
    t.integer  "doc_head_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",         :precision => 14, :scale => 4, :default=>1
    t.integer  "currency_id"
    t.decimal  "ori_amount",   :precision => 16, :scale => 2, :default => 0
    t.decimal  "st_amount",    :precision => 8,  :scale => 2
  end

  add_index "rd_extra_work_meals", ["currency_id"], :name => "index_rd_extra_work_meals_on_currency_id"
  add_index "rd_extra_work_meals", ["doc_head_id"], :name => "index_rd_extra_work_meals_on_doc_head_id"

  create_table "rd_lodgings", :force => true do |t|
    t.integer  "sequence"
    t.integer  "doc_head_id"
    t.integer  "region_id"
    t.integer  "days"
    t.integer  "people_count"
    t.string   "person_names"
    t.decimal  "apply_amount",   :precision => 16, :scale => 2, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",           :precision => 14, :scale => 4, :default=>1
    t.integer  "currency_id"
    t.decimal  "ori_amount",     :precision => 16, :scale => 2, :default => 0
    t.string   "custom_place"
    t.integer  "region_type_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.decimal  "st_amount",      :precision => 8,  :scale => 2
  end

  add_index "rd_lodgings", ["currency_id"], :name => "index_rd_lodgings_on_currency_id"
  add_index "rd_lodgings", ["doc_head_id"], :name => "index_rd_lodgings_on_doc_head_id"
  add_index "rd_lodgings", ["region_id"], :name => "index_rd_lodgings_on_region_id"
  add_index "rd_lodgings", ["region_type_id"], :name => "index_rd_lodgings_on_region_type_id"

  create_table "rd_transports", :force => true do |t|
    t.integer  "sequence"
    t.integer  "doc_head_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "start_position"
    t.string   "end_position"
    t.integer  "transportation_id"
    t.string   "reason"
    t.decimal  "apply_amount",      :precision => 16, :scale => 2, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",              :precision => 14, :scale => 4, :default=>1
    t.integer  "currency_id"
    t.decimal  "ori_amount",        :precision => 16, :scale => 2, :default => 0
  end

  add_index "rd_transports", ["currency_id"], :name => "index_rd_transports_on_currency_id"
  add_index "rd_transports", ["doc_head_id"], :name => "index_rd_transports_on_doc_head_id"
  add_index "rd_transports", ["transportation_id"], :name => "index_rd_transports_on_transportation_id"

  create_table "rd_travels", :force => true do |t|
    t.integer  "sequence"
    t.float  "days"
    t.integer  "region_id"
    t.string   "reason"
    t.string   "reason_type"
    t.string   "other_fee"
    t.string   "other_fee_description"
    t.decimal  "apply_amount",          :precision => 16, :scale => 2, :default => 0
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",                  :precision => 14, :scale => 4, :default=>1
    t.integer  "currency_id"
    t.decimal  "ori_amount",            :precision => 16, :scale => 2, :default => 0
    t.string   "custom_place"
    t.integer  "region_type_id"
    t.decimal  "st_amount",             :precision => 8,  :scale => 2
  end

  add_index "rd_travels", ["currency_id"], :name => "index_rd_travels_on_currency_id"
  add_index "rd_travels", ["doc_head_id"], :name => "index_rd_travels_on_doc_head_id"
  add_index "rd_travels", ["region_id"], :name => "index_rd_travels_on_region_id"
  add_index "rd_travels", ["region_type_id"], :name => "index_rd_travels_on_region_type_id"

  create_table "rd_work_meals", :force => true do |t|
    t.integer  "sequence"
    t.date     "meal_date"
    t.string   "place"
    t.integer  "people_count"
    t.string   "person_names"
    t.string   "reason"
    t.integer  "doc_head_id"
    t.decimal  "apply_amount", :precision => 16, :scale => 2, :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rate",         :precision => 14, :scale => 4, :default=>1
    t.integer  "currency_id"
    t.decimal  "ori_amount",   :precision => 16, :scale => 2, :default => 0
    t.integer  "dep_id"
    t.integer  "project_id"
  end

  add_index "rd_work_meals", ["currency_id"], :name => "index_rd_work_meals_on_currency_id"
  add_index "rd_work_meals", ["dep_id"], :name => "index_rd_work_meals_on_dep_id"
  add_index "rd_work_meals", ["doc_head_id"], :name => "index_rd_work_meals_on_doc_head_id"
  add_index "rd_work_meals", ["project_id"], :name => "index_rd_work_meals_on_project_id"

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
    t.decimal  "rate",        :precision => 14, :scale => 4, :default=>1
    t.integer  "doc_head_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recivers", :force => true do |t|
    t.integer  "sequence"
    t.integer  "settlement_id"
    t.string   "name"
    t.string   "bank"
    t.string   "bank_no"
    t.decimal  "amount",        :precision => 16, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
  end

  add_index "recivers", ["doc_head_id"], :name => "index_recivers_on_doc_head_id"
  add_index "recivers", ["settlement_id"], :name => "index_recivers_on_settlement_id"

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

  add_index "regions", ["code"], :name => "index_regions_on_code"
  add_index "regions", ["name"], :name => "index_regions_on_name"

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
    t.decimal  "amount",             :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "borrow_doc_head_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "menu_ids"
  end

  create_table "roles_menus", :force => true do |t|
    t.integer  "role_id"
    t.integer  "menu_id"
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

  add_index "settlements", ["code"], :name => "index_settlements_on_code"
  add_index "settlements", ["name"], :name => "index_settlements_on_name"

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

  create_table "suppliers", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "bank"
    t.string   "bank_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suppliers", ["code"], :name => "index_suppliers_on_code"
  add_index "suppliers", ["name"], :name => "index_suppliers_on_name"

  create_table "system_configs", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_configs", ["key"], :name => "index_system_configs_on_key"

  create_table "transportations", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transportations", ["code"], :name => "index_transportations_on_code"
  add_index "transportations", ["name"], :name => "index_transportations_on_name"

  create_table "u8_deps", :force => true do |t|
    t.string   "cdepcode"
    t.boolean  "bdepend"
    t.string   "cdepname"
    t.string   "idepgrade"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "u8codes", :force => true do |t|
    t.string   "cclass"
    t.string   "ccode"
    t.string   "ccode_name"
    t.string   "igrade"
    t.boolean  "bend"
    t.string   "cexch_name"
    t.boolean  "bperson"
    t.boolean  "bitem"
    t.boolean  "bdept"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "year"
    t.string   "name"
  end

  add_index "u8codes", ["name"], :name => "index_u8codes_on_name"

  create_table "u8service_configs", :force => true do |t|
    t.string   "dbname"
    t.string   "username"
    t.string   "password"
    t.integer  "year"
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

  create_table "vouches", :force => true do |t|
    t.string   "ino_id"
    t.string   "inid"
    t.string   "dbill_date"
    t.string   "idoc"
    t.string   "cbill"
    t.string   "doc_no"
    t.string   "ccode"
    t.string   "cexch_name"
    t.string   "md"
    t.string   "mc"
    t.string   "md_f"
    t.string   "mc_f"
    t.string   "nfrat"
    t.string   "cdept_id"
    t.string   "cperson_id"
    t.string   "citem_id"
    t.string   "ccode_equal"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "doc_head_id"
    t.integer  "dep_id"
    t.integer  "item_id"
    t.integer  "code_id"
    t.integer  "code_equal_id"
    t.integer  "person_id"
    t.string   "s_cdept_id"
    t.string   "s_cperson_id"
  end

  create_table "work_flow_infos", :force => true do |t|
    t.integer  "doc_head_id"
    t.integer  "vrv_project_id"
    t.boolean  "is_ok",       :default => true
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "approver_id"
  end

  create_table "work_flow_relate_steps", :force => true do |t|
    t.integer  "work_flow_id"
    t.integer  "work_flow_step_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sequence"
  end

  create_table "work_flow_steps", :force => true do |t|
    t.string   "factors"
    t.boolean  "is_self_dep"
    t.string   "step_code"
    t.decimal  "max_amount",   :precision => 8, :scale => 2
    t.string   "can_change_approver_steps"
    t.integer  "work_flow_id"
    t.boolean  "can_change_amount",:default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table :approver_infos do |t|
    t.integer :work_flow_step_id
    t.boolean :skip,:default => false
    t.integer :person_id
    t.integer :doc_head_id
    t.integer :vrv_project_id

    t.timestamps
  end

  create_table "work_flows", :force => true do |t|
    t.string   "name"
    t.string   "factors"
    t.integer  "priority"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "doc_types"
    t.string   "category"
  end

  create_table "work_flows_doc_meta_infos", :id => false, :force => true do |t|
    t.integer  "work_flow_id"
    t.integer  "doc_meta_info_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  #-------------------------------------------

  create_table :vrv_projects do |t|
    t.string :name
    t.string :code
    t.string :customer
    t.string :place
    t.string :website
    t.string :phone_pre
    t.string :phone_sur
    t.date :start_date
    t.string :scale
    t.string :amount
    t.string :customer_industry
    t.string :source
    t.string :agent_contact
    t.string :state
    t.integer :system_star
    t.integer :human_star
    t.integer :star
    t.integer :person_id
    t.integer  "current_approver_id"
    t.integer  "current_approver_info_id"

    t.timestamps
  end

  create_table :competitors do |t|
    t.string :name
    t.string :agent
    t.float :price
    t.integer :vrv_project_id

    t.timestamps
  end

  create_table :network_conditions do |t|
    t.string :ip_address
    t.string :hub
    t.string :dns_server
    t.string :windows_domain
    t.string :network_connection
    t.string :physical_keep
    t.string :port_listen
    t.string :network_inside
    t.integer :vrv_project_id

    t.timestamps
  end

  create_table :products do |t|
    t.string :name
    t.string :code

    t.timestamps
  end

  create_table :contract_items do |t|
    t.integer :product_id
    t.integer :quantity
    t.decimal :price,      :precision => 16, :scale => 2
    t.float :service_year
    t.decimal :amount,      :precision => 16, :scale => 2
    t.integer :doc_head_id

    t.timestamps
  end

  create_table "network_conditions_products", :id => false, :force => true do |t|
    t.integer "network_condition_id"
    t.integer "product_id"
  end

  create_table :tech_communications do |t|
    t.date :date
    t.string :customer
    t.string :customer_work_phone
    t.string :customer_cell
    t.string :duty
    t.string :contents
    t.string :feedback
    t.date :customer_project_start_date
    t.string :has_tech_people
    t.string :our_tech_guy
    t.string :our_tech_guy_contact
    t.string :tech_level
    t.string :tech_attitude
    t.text :others
    t.integer :vrv_project_id

    t.timestamps
  end

  create_table :busi_communications do |t|
    t.date :date
    t.string :person
    t.string :duty
    t.string :phone
    t.string :way
    t.string :feedback
    t.text :others
    t.integer :vrv_project_id

    t.timestamps
  end
  create_table :product_tests do |t|
    t.date :date
    t.string :customer
    t.string :sample
    t.string :sample_state
    t.string :customer_attitude
    t.string :test_result
    t.string :has_tech_people
    t.string :our_tech_guy
    t.string :our_tech_guy_contact
    t.string :tech_people_point
    t.string :test_product_order
    t.string :customer_like
    t.text :others
    t.integer :vrv_project_id

    t.timestamps
  end

  create_table :bill_prepares do |t|
    t.string :sample_choose
    t.string :price_point
    t.string :price_cal_way
    t.text :others
    t.integer :vrv_project_id

    t.timestamps
  end
  create_table :contract_predicts do |t|
    t.text :product
    t.integer :package_num
    t.float :points
    t.float :price
    t.date :sign_date
    t.integer :vrv_project_id
    t.string :bill_percent

    t.timestamps
  end

  create_table :bill_stages do |t|
    t.string :sample_choose
    t.string :price_point
    t.string :price_cal_way
    t.string :price_sample
    t.text :others
    t.integer :vrv_project_id

    t.timestamps
  end

  create_table :bill_afters do |t|
    t.string :bill_state
    t.string :contract
    t.string :money_back
    t.date :pay_date
    t.date :begin_implement_date
    t.date :end_implement_date
    t.date :accept_date
    t.text :others
    t.float :bill_price
    t.integer :vrv_project_id

    t.timestamps
  end

  create_table :implement_activities do |t|
    t.string :engineer
    t.date :start_date
    t.date :end_date
    t.float :days
    t.integer :doc_head_id
    t.integer :vrv_project_id

    t.timestamps
  end

  create_table :customer_contacts do |t|
    t.string :name
    t.string :duty
    t.string :phone
    t.string :email
    t.integer :vrv_project_id

    t.timestamps
  end

  create_table :vrv_project_versions do |t|
    t.string   :item_type, :null => false
    t.integer  :item_id,   :null => false
    t.string   :event,     :null => false
    t.string   :whodunnit
    t.text     :object
    t.datetime :created_at
    t.text     :object_changes
    t.string   :ip
    t.text     :user_agent
    t.integer  :vrv_project_id
    t.integer  :person_id
  end
  add_index :vrv_project_versions, [:item_type, :item_id]
end
