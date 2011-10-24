#coding: utf-8
class RdLodging < ActiveRecord::Base
  include DocIndex
  include AdjustAmount
  before_validation :set_apply_amount
  def set_apply_amount
    self.apply_amount = self.ori_amount / self.rate
  end
  belongs_to :region
  belongs_to :reim_detail
  belongs_to :currency
  belongs_to :region_type
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"

  validates_presence_of :ori_amount
  validates_presence_of :start_date
  validates_presence_of :end_date
  validates_presence_of :rate
  validates_presence_of :currency_id
  validates_presence_of :people_count
  validates_presence_of :days
  validate :must_have_live_person,:must_have_a_place,:amout_validation
  def must_have_live_person
    errors.add(:person_names,"当住宿人数大于1时，合住人必填") if people_count and people_count>1 and person_names.blank?
  end
  def must_have_a_place
    errors.add(region_id ? :custom_place : :region_id,"出差地点或者其他地点必须录入一个") if region_id==nil and custom_place.blank?
  end
  def amout_validation
    errors.add(:ori_amount,"差旅住宿费中原币金额不能大于 天数*费用标准*人数") if st_amount&&ori_amount&&people_count&&days and ori_amount>people_count*st_amount*days
  end
  def self.read_only_attr?(attr)
    %w(apply_amount fi_amount hr_amount).include?(attr)
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
