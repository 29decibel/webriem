#coding: utf-8
class RdWorkMeal < ActiveRecord::Base
  include DocIndex
  include FeeType
  before_validation :set_apply_amount
  def set_apply_amount
    self.apply_amount = self.ori_amount / self.rate
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
  belongs_to :reim_detail
  belongs_to :currency
  belongs_to :project
  belongs_to :dep
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"

  validates_presence_of :place
  validates_presence_of :meal_date
  validates_presence_of :people_count
  validates_presence_of :person_names
  validates_presence_of :reason
  validates_presence_of :ori_amount
  validates_presence_of :currency_id
  validates_presence_of :rate
  validates_presence_of :project_id
  def self.read_only_attr?(attr)
    %w(apply_amount fi_amount hr_amount).include?(attr)
  end
  def fcm
    FeeCodeMatch.find_by_fee_code("0102")
  end
end
