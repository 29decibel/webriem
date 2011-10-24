#coding: utf-8
class CommonRiem < ActiveRecord::Base
  include DocIndex
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
end
