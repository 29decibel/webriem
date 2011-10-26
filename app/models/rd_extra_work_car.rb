#coding: utf-8
class RdExtraWorkCar < ActiveRecord::Base
  include DocIndex
  include AdjustAmount
  before_validation :set_apply_amount
  def set_apply_amount
    self.apply_amount = self.ori_amount / self.rate
  end
  belongs_to :reim_detail  
  belongs_to :currency
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"

  validates_presence_of :start_time
  validates_presence_of :end_time
  validates_presence_of :start_place
  validates_presence_of :end_place
  validates_presence_of :reason
  validates_presence_of :currency_id
  validates_presence_of :rate
  validates_presence_of :ori_amount
  default_scope :order => 'start_time ASC'
  validate :time_validate
  def self.read_only_attr?(attr)
    %w(apply_amount fi_amount hr_amount).include?(attr)
  end
  def time_validate
    if start_time !=nil and end_time!=nil
      errors.add(:start_time,"请检查填写的日期或时间") if start_time>Time.now
      errors.add(:end_time,"请检查填写的日期或时间") if end_time>Time.now
    end
  end
  def fcm
    return FeeCodeMatch.find_by_fee_code("0602")
  end
  def project
    doc_head.project
  end
  def dep
    doc_head.afford_dep
  end
end
