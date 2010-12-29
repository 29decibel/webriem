#coding: utf-8
class Subject < ActiveRecord::Base
  belongs_to :fee
  belongs_to :dep
  belongs_to :business_type
  blongs_to_name_attr :business_type
  blongs_to_name_attr :fee
  blongs_to_name_attr :dep
  netzke_exclude_attributes :created_at, :updated_at
  #enum_attr :busitype,[['借款',0],['报销',1],['其他',2]]
  validates_presence_of :fee_id,:dep_id
  validate :must_input_one_u8_subject
  def must_input_one_u8_subject
    errors.add(:base, "费用科目、借款科目、报销科目中至少录入一个") if
      u8_fee_subject.empty? && u8_borrow_subject.empty? && u8_reim_subject.empty?
  end
  #===================================================================================
  CUSTOM_QUERY={
      'fee_id'=>{:include=>:fee,:conditions=>'fees.name like ?'},
      'dep_id'=>{:include=>:dep,:conditions=>'deps.name like ?'},
      'business_type_id'=>{:include=>:business_type,:conditions=>'business_types.name like ?'},
  }
  def self.custom_query(column_name,filter_text)
    if CUSTOM_QUERY.has_key? column_name
      CUSTOM_QUERY[column_name]
    else
      nil
    end
  end
  def to_s
    "#{name}"
  end
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if dep and dep.sub_deps.count>0
  end
end
