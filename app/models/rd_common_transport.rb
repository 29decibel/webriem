#coding: utf-8
class RdCommonTransport < ActiveRecord::Base
  belongs_to :reim_detail  
  belongs_to :currency
  belongs_to :dep
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
  validate :dep_is_end,:time_validate
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if dep and dep.sub_deps.count>0
  end
  def time_validate
    if start_time !=nil and end_time!=nil
      errors.add(:start_time,"请检查填写的日期或时间") if start_time>Time.now
      errors.add(:end_time,"请检查填写的日期或时间") if end_time>Time.now
    end
  end
end
