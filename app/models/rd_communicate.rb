#coding: utf-8
class RdCommunicate < ActiveRecord::Base
  include DocIndex
  include FeeType

  INVOICE_TYPE = %w(机打 非机打)
  before_validation :set_apply_amount

  before_save :set_afford_dep
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
  belongs_to :reim_detail
  belongs_to :currency
  belongs_to :project
  belongs_to :dep
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"

  validates_presence_of :meal_date
  validates_presence_of :reason
  validates_presence_of :ori_amount
  validates_presence_of :currency_id
  validates_presence_of :rate
  validates_presence_of :project_id
  validates_presence_of :invoice_date
  validates :invoice_type,:inclusion=>INVOICE_TYPE
  validate :invoice_date_valid
  def self.read_only_attr?(attr)
    %w(apply_amount fi_amount hr_amount).include?(attr)
  end
  def fcm
    FeeCodeMatch.find_by_fee_code("02")
  end

  #这个人（职务）在这个月（期间）内项目招待费不能超过3000
  #这个人（职务）这个月在这种项目类型上的招待费不能超过700
  def test_rule
    result = {}
    rules = FeeRule.of_class(self.class.name).select{|r|r.match?(self)}
  end


  def set_afford_dep
    if project
      self.dep = project.dep
    end
  end

  def set_apply_amount
    self.apply_amount = self.rate * self.ori_amount
  end
  def invoice_date_valid
    errors.add(:invoice_date,'发票时间不能早于报销时间10天以上') if (self.doc_head.apply_date.to_time-invoice_date.to_time) > 10.days
  end
end
