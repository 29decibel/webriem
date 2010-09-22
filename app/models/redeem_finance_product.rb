class RedeemFinanceProduct < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :account
end
