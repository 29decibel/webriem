#coding: utf-8
class WorkFlowStep < ActiveRecord::Base
  belongs_to :work_flow
  belongs_to :dep
  belongs_to :duty
  enum_attr :is_self_dep, [['是', 0], ['否', 1]]
end
