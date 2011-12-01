#coding: utf-8
class CustomerContact < ActiveRecord::Base
  has_paper_trail :class_name=>'VrvProjectVersion',
    :meta=>{:vrv_project_id => Proc.new{|r|r.vrv_project.id},
            :state => Proc.new{|r|r.vrv_project.state},
            :person_id => Proc.new{|r|r.vrv_project.person_id} }

  validates_presence_of :name,:duty,:phone
  validate :phone_no_valid
  belongs_to :vrv_project

  def phone_no_valid
    errors.add(:phone,'号码不合法') if self.phone.try(:size)!=11
  end
end
