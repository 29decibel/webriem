#coding: utf-8
class RdTravel < ActiveRecord::Base
  include DocIndex
  before_validation :set_apply_amount
  def set_apply_amount
    self.apply_amount = self.rate * self.ori_amount
  end
  belongs_to :reim_detail
  belongs_to :fee_standard
  belongs_to :region
  belongs_to :currency
  belongs_to :region_type
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"

  validates_presence_of :ori_amount
  validates_presence_of :days
  validates_presence_of :reason
  validates_presence_of :rate
  validates_presence_of :currency_id
  validate :must_have_a_place
  def must_have_a_place
    errors.add(:base,"出差地点或者其他地点必须录入一个") if region_id==nil and custom_place.blank?
  end
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
