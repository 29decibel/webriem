#coding: utf-8
class TechCommunication < ActiveRecord::Base
  has_paper_trail :class_name=>'VrvProjectVersion',
    :meta=>{:vrv_project_id => Proc.new{|r|r.vrv_project.id},
            :state => Proc.new{|r|r.vrv_project.state},
            :person_id => Proc.new{|r|r.vrv_project.person_id} }
  belongs_to :vrv_project

  DUTY = %w(基层技术人员 项目负责人/项目主管(处长级) 主管主任(司局级) 采购部门 总裁级(单位最高领导人级))
  CONTENTS = %w(送达资料 PPT产品交流 提交方案 安装试用产品 约定下次交流)
  FEEDBACK = %w(有难度 有进入下一步意向 我们有机会 非常满意)
  TECH_LEVEL = %w(讲解不清楚 无法把握用户，用户提出自己的见解和需求 可以引导用户，用户满意)
  TECH_ATTITUDE = %w(不积极 比较配合 积极主动)
  HAS_TECH_PEOPLE = %w(有 无)

  validates :duty,:inclusion => DUTY
  validates :contents,:inclusion => CONTENTS
  validates :feedback,:inclusion => FEEDBACK
  validates :tech_level,:inclusion => TECH_LEVEL
  validates :tech_attitude,:inclusion => TECH_ATTITUDE
  validates :has_tech_people,:inclusion => HAS_TECH_PEOPLE

  validates_presence_of :date,:customer,:customer_work_phone,:customer_cell,:duty,:contents,:feedback,:customer_project_start_date,:has_tech_people,:our_tech_guy,:our_tech_guy_contact,:tech_level,:tech_attitude
end
