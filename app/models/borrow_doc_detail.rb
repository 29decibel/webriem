#coding: utf-8
class BorrowDocDetail < ActiveRecord::Base
  include DocIndex

  before_save :set_afford_dep
  before_validation :set_apply_amount

  after_initialize  :set_default_value
  def set_default_value
    if !currency
      sysconfig = SystemConfig.find_by_key 'default_currency'
      if sysconfig
        self.currency = Currency.find_by_code sysconfig.value
        self.rate = self.currency.default_rate if self.currency
      end
    end
  end

  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"
  belongs_to :dep
  belongs_to :fee
  belongs_to :project
  belongs_to :currency

  validates_presence_of :ori_amount
  validates_presence_of :project_id
  validates_presence_of :currency_id
  validates_presence_of :rate
  validates_presence_of :used_for
  def self.read_only_attr?(attr)
    %w(apply_amount fi_amount hr_amount).include?(attr)
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

  private
  def set_afford_dep
    if project
      self.dep = project.dep
    end
  end
  def set_apply_amount
    self.apply_amount = self.ori_amount / self.rate
  end

end
