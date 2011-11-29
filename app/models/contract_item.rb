class ContractItem < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :product
  validates_presence_of :amount,:service_year,:price,:product_id,:quantity
  validates :quantity,:numericality => {:greater_than => 0}
  validates :amount,:numericality => {:greater_than => 0}

  after_validation :set_price

  def apply_amount
    amount || 0
  end

  def self.read_only_attr?(attr)
    %w(price).include?(attr)
  end

  def set_price
    self.price = amount/quantity
  end
end
