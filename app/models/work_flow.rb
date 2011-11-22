#coding: utf-8
class WorkFlow < ActiveRecord::Base
  CATEGORY = %w(报销系统 立项系统)

  validates :category,:inclusion => CATEGORY
  has_many :work_flow_steps,:class_name=>"WorkFlowStep",:foreign_key => 'work_flow_id'
           
  has_and_belongs_to_many :doc_meta_infos
  has_and_belongs_to_many :duties
  accepts_nested_attributes_for :work_flow_steps ,:allow_destroy => true

  scope :oes,where('category=?','报销系统')
  scope :project,where('category=?','立项系统')

end
