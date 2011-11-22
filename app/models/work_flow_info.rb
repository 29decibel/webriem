#coding: utf-8
class WorkFlowInfo < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :vrv_project
  belongs_to :approver, :class_name => "Person", :foreign_key => "approver_id"
end
