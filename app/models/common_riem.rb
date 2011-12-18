#coding: utf-8
class CommonRiem < ActiveRecord::Base
  include DocIndex
  include FeeType
  include SensitiveWordValidation
  INVOICE_TYPE = %w(机打 非机打)
  before_validation :set_apply_amount
  def set_apply_amount
    self.apply_amount = self.rate * self.ori_amount
  end
  before_save :set_afford_dep
  def set_afford_dep
    if project
      self.dep = project.dep
    end
  end
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
  belongs_to :currency
  belongs_to :dep
  belongs_to :fee
  belongs_to :project
  belongs_to :doc_head
  validates_presence_of :project_id
  validates_presence_of :description
  validates_presence_of :currency_id
  validates_presence_of :rate
  validates_presence_of :ori_amount
  validates_presence_of :invoice_date
  validates :invoice_type,:inclusion=>INVOICE_TYPE
  validate :invoice_date_valid
  def amount
    apply_amount
  end

  def self.read_only_attr?(attr)
    %w(apply_amount fi_amount hr_amount).include?(attr)
  end

  def fcm
    fee_code_match= FeeCodeMatch.find_by_fee_code("01")
    if fee
      fc=FeeCodeMatch.find_by_fee_code(fee.code)
      return fc if fc
    end
    return fee_code_match
  end

  def invoice_date_valid
    logger.info '##############################################################################################'
    logger.info doc_head
    logger.info '##############################################################################################'
    if self.invoice_date
      errors.add(:invoice_date,'发票时间不能早于报销时间10天以上') if (self.doc_head.apply_date.to_time-invoice_date.to_time) > 10.days
    end
  end
end
