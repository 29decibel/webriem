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
  validates_presence_of :fee_id,:factors,:amount
  belongs_to :fee
  scope :rule,    lambda {|rule| where("factors like ?",rule)}

  def match_factors?(p_factors_string)
    p_fac = factor_hash(p_factors_string)
    r_fac = factor_hash(self.factors)
    puts p_fac
    puts r_fac
    puts p_fac.merge(r_fac)
    p_fac.merge(r_fac)==p_fac
  end

  def to_s
    "#{fee.name}预算 --- #{factors},预算金额为￥#{amount}"
  end

  private

  def factor_hash(factor_string)
    rule_fa = {}
    factor_string.split(',').each do |f|
      key,value = f.split(':')
      rule_fa[key.strip]=value.try(:strip)
    end 
    rule_fa
  end

end
