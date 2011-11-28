#coding: utf-8
class ContractPredict < ActiveRecord::Base
  has_paper_trail :class_name=>'VrvProjectVersion',
    :meta=>{:vrv_project_id => Proc.new{|r|r.vrv_project.id},
            :state => Proc.new{|r|r.vrv_project.state},
            :person_id => Proc.new{|r|r.vrv_project.person_id} }


  belongs_to :vrv_project
  validates_presence_of :product,:package_num,:points,:price,:sign_date,:bill_percent
  BILL_PERCENT = %w(50%以下 50%-80% 80%以上)

  validates :bill_percent,:inclusion => BILL_PERCENT
end
