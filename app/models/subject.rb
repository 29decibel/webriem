#coding: utf-8
class Subject < ActiveRecord::Base
  belongs_to :fee
  belongs_to :dep
  blongs_to_name_attr :fee
  blongs_to_name_attr :dep
  enum_attr :busitype,[['借款',0],['报销',1],['其他',2]]
  validates_presence_of :busitype,:fee_id,:dep_id
  validate :must_input_one_u8_subject
    def must_input_one_u8_subject
      errors.add(:base, "费用科目、借款科目、报销科目中至少录入一个") if
        u8_fee_subject.empty? && u8_borrow_subject.empty? && u8_reim_subject.empty?
    end
end
