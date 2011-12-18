#coding: utf-8
class RdTransport < ActiveRecord::Base
  include DocIndex
  include FeeType
  include SensitiveWordValidation
  before_validation :set_apply_amount
  def set_apply_amount
    self.apply_amount = self.ori_amount / (self.rate||1)
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
    belongs_to :reim_detail
    belongs_to :transportation, :class_name => "Transportation", :foreign_key => "transportation_id"
    belongs_to :currency
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"

    validates_presence_of :ori_amount
    validates_presence_of :start_date
    validates_presence_of :end_date
    validates_presence_of :start_position
    validates_presence_of :end_position
    validates_presence_of :transportation_id
    validates_presence_of :reason
    validates_presence_of :rate
    validates_presence_of :currency_id
    default_scope :order => 'start_date ASC'
    validate :time_validate
    def time_validate
      if start_date !=nil and end_date!=nil
        errors.add(:start_date,"请检查填写的日期或时间") if start_date>Time.now
        errors.add(:end_date,"请检查填写的日期或时间") if end_date>Time.now
      end
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
