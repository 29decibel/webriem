#coding: utf-8
class CommonRiem < ActiveRecord::Base
  before_save :set_apply_amount
  def set_apply_amount
    self.apply_amount = self.rate * self.ori_amount
  end
  belongs_to :currency
  belongs_to :dep
  belongs_to :fee
  belongs_to :project
  belongs_to :doc_head
  validates_presence_of :dep_id
  validates_presence_of :project_id
  validates_presence_of :description
  validates_presence_of :currency_id
  validates_presence_of :rate
  validates_presence_of :ori_amount
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if dep and dep.sub_deps.count>0
  end
  def amount
    apply_amount
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
