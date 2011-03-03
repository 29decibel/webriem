#coding: utf-8
class Fee < ActiveRecord::Base
  belongs_to :parent_fee, :class_name => "Fee", :foreign_key => "parent_fee_id"
  blongs_to_name_attr :parent_fee
  has_many :fees, :class_name => "Fee", :foreign_key => "parent_fee_id"
  enum_attr :attr, [['普通费用', 0], ['差旅费用', 1], ['加班费用', 2], ['交际费用', 3], ['业务交通费', 4], ['福利费', 5], ['收款通知', 6], ['结汇申请',7], ['现金提取申请', 8], ['购买（赎回）理财产品申请', 9]]
  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  #===================================================================================
  CUSTOM_QUERY={
      'parent_fee_id'=>{:include=>:parent_fee,:conditions=>'parent_fees_fees.name like ?'},
  }
  def self.custom_query(column_name,filter_text)
    if CUSTOM_QUERY.has_key? column_name
      CUSTOM_QUERY[column_name]
    else
      nil
    end
  end
  #===================================================================================
  def to_s
    "#{name}[#{code}]"
  end
end
