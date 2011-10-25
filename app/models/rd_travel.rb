#coding: utf-8
class RdTravel < ActiveRecord::Base
  include DocIndex
  include AdjustAmount
  before_validation :set_apply_amount
  def set_apply_amount
    self.apply_amount = (self.ori_amount||0) / (self.rate || 1)
  end

  after_initialize :set_default_days,:if => Proc.new { |travel| !travel.days and travel.new_record? }
  def set_default_days
    self.days = 2
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
  REASON_TYPES = %w(实施 非实施)
  validates_inclusion_of :reason_type, :in => REASON_TYPES
  validate :must_have_a_place

  def must_have_a_place
    errors.add(region_id ? :custom_place : :region_id,"出差地点或者其他地点必须录入一个") if region_id==nil and custom_place.blank?
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
