class ApproverInfo < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :vrv_project
  belongs_to :work_flow_step
  belongs_to :person

  before_create :set_person_select

  def dep
    @dep || (
    if doc_head
      @dep = doc_head.real_person.try(:dep) || doc_head.person.dep # only is_self_dep need the change dep accord the real person
    else
      @dep = vrv_project.person.dep
    end)
  end

  def candidates
    if work_flow_step.is_self_dep
      while dep do
        ps = Person.where("dep_id=? and duty_id=?",dep.id,work_flow_step.duty_id)
        if ps.count>0
          return ps
        end
        dep = dep.parent_dep
      end #end while
      []
    else
      Person.where("dep_id = ? and duty_id =?",work_flow_step.dep_id,work_flow_step.duty_id)
    end #end is self dep
  end

  private
  # set the person if there is only one person
  def set_person_select
    approvers = candidates
    self.person = approvers.first if (approvers.count==1)
  end
end
