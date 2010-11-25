#coding: utf-8
class BuyFinanceProduct < ActiveRecord::Base
  belongs_to :account, :class_name => "Account", :foreign_key => "account_id"
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"
end
