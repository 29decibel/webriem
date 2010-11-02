#coding: utf-8
class RdLodging < ActiveRecord::Base
  belongs_to :region
  belongs_to :reim_detail
  belongs_to :currency
  belongs_to :region_type
  validates_presence_of :ori_amount
  validate :must_have_live_person,:less_than_st_amount

  def must_have_live_person
    errors.add(:base,"当住宿人数大于1时，合住人必填") if people_count and people_count>1 and person_names.blank?
  end
  def less_than_st_amount
    errors.add(:base,"报销住宿费的金额必须小于等于住宿标准标准*人数") if ori_amount and st_amount and people_count and ori_amount>st_amount*people_count
  end
  def after_initialize
    self.currency=Currency.find_by_code("RMB")
    if self.currency
      self.rate=self.currency.default_rate
    end
  end
end
