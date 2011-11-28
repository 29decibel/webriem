#coding: utf-8
class WorkFlow < ActiveRecord::Base
  CATEGORY = %w(报销系统 立项系统)

  validates :category,:inclusion => CATEGORY
  validates_presence_of :name,:factors,:doc_meta_infos
  has_many :work_flow_steps,:class_name=>"WorkFlowStep",:foreign_key => 'work_flow_id'
           
  has_and_belongs_to_many :doc_meta_infos
  accepts_nested_attributes_for :work_flow_steps ,:allow_destroy => true

  scope :oes,where('category=?','报销系统')
  scope :project,where('category=?','立项系统')

  def match_factors?(p_factors_string)
    p_fac = factor_hash(p_factors_string)
    r_fac = factor_hash(self.factors||'')
    puts p_fac
    puts r_fac
    puts p_fac.merge(r_fac)
    p_fac.merge(r_fac)==p_fac
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
