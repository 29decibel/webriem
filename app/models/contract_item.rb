class ContractItem < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :product

  validates_presence_of :amount,:if=>:is_ht?
  validates_presence_of :service_year,:if=>:is_ht?
  validates_presence_of :product_id
  validates_presence_of :quantity
  validates :quantity,:numericality => {:greater_than => 0}
  validates :amount,:numericality => {:greater_than => 0},:if=>:is_ht?

  after_validation :set_price

  def is_ht?
    self.doc_head and self.doc_head.doc_meta_info.code=='HT'
  end

  def apply_amount
    amount || 0
  end

  def self.read_only_attr?(attr)
    %w(price).include?(attr)
  end

  def set_price
    self.price = amount/quantity if self.is_ht?
  end
end
