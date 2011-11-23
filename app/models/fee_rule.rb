#coding: utf-8
# ---------业务招待费用
# ============================================
# 这个人（职务）在这个月（期间）内项目招待费不能超过3000
# 这个人（职务）这个月在这种项目类型上的招待费不能超过700
# ============================================
# 
# ---------住宿费用
# 
# 职务+地区+ 每天标准
# 
# ---------出差补助
# 和职务没有关系，只要是这些地区就是这个标准（按天）
# 
# 北京 上海 深圳 60
# 其他 50
# 
# 实施类项目 + 20
#
# duty:001;period:month;                        3000
# duty:004;period:month;vrv_project_type:004    700
#
# duty:004;place:004;period:day                 40
#
# place:004;period:day                          60
# place:
#
# 只考虑没有子的规则
# 或者是叶子规则，每个叶子规则都是基于父规则的，
# 也就是说他的规则是串联所有父亲规则的总和
# if the previous values of factors equals the values setting
# 如果这个规则上所有属性都等于预先设定的值
class FeeRule < ActiveRecord::Base
  scope :fee,lambda {|class_name| where("fee_class=?",class_name)}
  scope :rule,    lambda {|rule| where("factors like %#{rule}%")}
  default_scope order('priority desc')

  before_save :reorder_factors

  def self.match(person,fee_class)
    
  end

  private
  def reorder_factors
    self.factors = self.factors.split(',').sort.join(',')
  end

end
