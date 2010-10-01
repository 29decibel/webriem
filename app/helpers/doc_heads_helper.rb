module DocHeadsHelper
  #这个step对应的那个人是谁
  def get_person_from_wfs(work_flow_step,cu)
    person=nil
    #不是本部门的直接找
    if work_flow_step.is_self_dep==0
      person=Person.where("dep_id=? and duty_id=?",work_flow_step.dep_id,work_flow_step.duty_id).first
    else
      dep=cu.person.dep
      while dep
        person=Person.where("dep_id=? and duty_id=?",dep.id,work_flow_step.duty_id).first
        break if person
        dep=dep.parent_dep
      end
    end
    person
  end
end
