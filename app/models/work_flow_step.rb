#coding: utf-8
class WorkFlowStep < ActiveRecord::Base

  has_many :work_flows,:through => :work_flow_relate_steps
  has_many :work_flow_relate_steps

  belongs_to :dep
  belongs_to :duty
  validates_presence_of :duty_id

  def name
    if is_self_dep
      "由所在部门的#{duty.name}进行审批"
    else
      "由#{dep.name}的#{duty.name}进行审批"
    end
  end

end
