#coding: utf-8
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
