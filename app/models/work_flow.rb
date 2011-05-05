#coding: utf-8
class WorkFlow < ActiveRecord::Base
  has_many :work_flow_steps, :class_name => "WorkFlowStep", :foreign_key => "work_flow_id"
  has_and_belongs_to_many :duties
  accepts_nested_attributes_for :work_flow_steps ,:allow_destroy => true
end
