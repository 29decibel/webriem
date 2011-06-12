#coding: utf-8
class WorkFlow < ActiveRecord::Base

  has_many :work_flow_steps,:through => :work_flow_relate_steps,:order => :sequence,
           :after_add=>:update_sequence,:after_remove=>:update_sequence
  has_many :work_flow_relate_steps,:order=>:sequence
  has_and_belongs_to_many :doc_meta_infos

  has_and_belongs_to_many :duties
  accepts_nested_attributes_for :work_flow_steps ,:allow_destroy => true

  def update_sequence(work_flow_step)
    work_flow_relate_steps.each_with_index do |w,index|
      w.update_attribute :sequence,index
    end
  end
end
