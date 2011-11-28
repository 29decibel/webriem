#coding: utf-8
class WorkFlowStep < ActiveRecord::Base

  has_many :work_flows,:through => :work_flow_relate_steps
  has_many :work_flow_relate_steps

  validates_presence_of :factors

  def name
    if is_self_dep
      "由所在部门的#{factors}进行审批"
    else
      "由#{factors}进行审批"
    end
  end

end
