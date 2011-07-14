#coding: utf-8
class WorkFlowInfo < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :approver, :class_name => "Person", :foreign_key => "approver_id"
  enum_attr :is_ok, [["是", 1],["否",0]]
end
