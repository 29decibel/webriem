class ContractItem < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :product

  def apply_amount
    amount
  end
end
