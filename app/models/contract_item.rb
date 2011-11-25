class ContractItem < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :product
  validates_presence_of :amount

  def apply_amount
    amount || 0
  end
end
