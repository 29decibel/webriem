#coding: utf-8
class OtherRiem < ActiveRecord::Base
  include DocIndex
  include AdjustAmount
  before_validation :set_apply_amount
  def set_apply_amount
    self.apply_amount = self.ori_amount / self.rate
  end
  belongs_to :doc_head
  belongs_to :currency
  validates_presence_of :rate
  validates_presence_of :currency_id
  validates_presence_of :description
  def fcm
    return FeeCodeMatch.find_by_fee_code("03")
  end
  def project
    doc_head.project
  end
  def dep
    doc_head.afford_dep
  end
end
