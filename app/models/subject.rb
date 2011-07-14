#coding: utf-8
class Subject < ActiveRecord::Base
  belongs_to :fee
  belongs_to :dep
  belongs_to :business_type
  #enum_attr :busitype,[['借款',0],['报销',1],['其他',2]]
  validates_presence_of :fee_id,:dep_id
  validate :must_input_one_u8_subject
  def must_input_one_u8_subject
    errors.add(:base, "费用科目、借款科目、报销科目中至少录入一个") if
      u8_fee_subject.empty? && u8_borrow_subject.empty? && u8_reim_subject.empty?
  end

  def to_s
    "#{name}"
  end
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if dep and dep.sub_deps.count>0
  end
end
