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
  def after_initialize
    self.currency=Currency.find_by_code("RMB")
    if self.currency
      self.rate=self.currency.default_rate
    end
  end
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if dep and dep.sub_deps.count>0
  end
end
