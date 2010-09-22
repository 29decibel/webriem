class InnerTransfer < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :account, :class_name => "Account", :foreign_key => "out_account"
end
