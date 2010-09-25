#coding: utf-8
class WorkFlowInfo < ActiveRecord::Base
  belongs_to :doc_head
  enum_attr :is_ok, [['否', 0], ['是', 1]]
end
