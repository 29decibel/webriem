#coding: utf-8
class CpDocDetail < ActiveRecord::Base

  before_save :set_apply_amount
  def set_apply_amount
    self.apply_amount = self.rate * self.ori_amount
  end

  after_initialize  :set_default_value
  def set_default_value
    if !currency
      sysconfig = SystemConfig.find_by_key 'default_currency'
      if sysconfig
        self.currency = Currency.find_by_code sysconfig.value
        self.rate = self.currency.default_rate
      end
    end
  end

  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"
  belongs_to :dep
  belongs_to :fee
  belongs_to :project
  belongs_to :currency

  validates_presence_of :dep_id
  validates_presence_of :ori_amount
  validates_presence_of :currency_id
  validates_presence_of :rate
  validates_presence_of :used_for
  validate :dep_is_end

  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if dep and dep.sub_deps.count>0
  end
  def amount
    self.apply_amount
  end
  #for the vouch info
  def fcm
    return nil if doc_head==nil
    fee_m_code=doc_head.doc_type==1 ? FeeCodeMatch.find_by_fee_code("07") : FeeCodeMatch.find_by_fee_code("08")
    if fee
      fcm= FeeCodeMatch.find_by_fee_code(fee.code)
      if fcm
        fee_m_code=fcm
      end
    end
    return fee_m_code
  end
end
