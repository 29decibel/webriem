#coding: utf-8
class WorkFlowInfo < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :person, :class_name => "Person", :foreign_key => "people_id"
  blongs_to_name_attr :person
  enum_attr :is_ok, [['否',0],['是', 1]]
  validates_uniqueness_of :people_id, :scope => [:doc_head_id]
end
