class ImplementActivity < ActiveRecord::Base
  has_paper_trail :class_name=>'VrvProjectVersion',
    :meta=>{:vrv_project_id => Proc.new{|r|r.vrv_project.id},
            :state => Proc.new{|r|r.vrv_project.state},
            :person_id => Proc.new{|r|r.vrv_project.person_id} }

  belongs_to :vrv_project
  belongs_to :doc_head
  after_validation :set_project

  validates_presence_of :doc_head_id,:engineer,:start_date,:end_date,:days

  private
  def set_project
    self.vrv_project = doc_head.contract_doc.try(:vrv_project) if doc_head
  end

end
