class InnerRemittance < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :out_account, :class_name => "Account", :foreign_key => "out_account_id"
  belongs_to :in_account, :class_name => "Account", :foreign_key => "in_account_id"
  belongs_to :currency
  def after_initialize
    self.currency=Currency.find_by_code("USD")
  end
end
