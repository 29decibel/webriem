#coding: utf-8
class RdCommonTransport < ActiveRecord::Base
  before_save :set_apply_amount
  def set_apply_amount
    self.apply_amount = self.rate * self.ori_amount
  end
  before_save :set_afford_dep
  def set_afford_dep
    if project
      self.dep = project.dep
    end
  end
  belongs_to :reim_detail  
  belongs_to :currency
  belongs_to :project
  validates_presence_of :ori_amount
  validates_presence_of :start_place
  validates_presence_of :end_place
  validates_presence_of :start_time
  validates_presence_of :end_time
  validates_presence_of :currency_id
  validates_presence_of :rate
  validates_presence_of :reason
  validates_presence_of :dep_id
  default_scope :order => 'start_time ASC'
  validate :time_validate
  def time_validate
    if start_time !=nil and end_time!=nil
      errors.add(:start_time,"请检查填写的日期或时间") if start_time>Time.now
      errors.add(:end_time,"请检查填写的日期或时间") if end_time>Time.now
    end
  end
  def fcm
    return FeeCodeMatch.find_by_fee_code("0103")
  end
end
