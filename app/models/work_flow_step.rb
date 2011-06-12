#coding: utf-8
class WorkFlowStep < ActiveRecord::Base
  belongs_to :work_flow
  belongs_to :dep
  belongs_to :duty

  def name
    if is_self_dep
      "由所在部门的#{duty.name}进行审批"
    else
      "由#{dep.name}的#{duty.name}进行审批"
    end
  end
end
