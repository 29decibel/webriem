#coding: utf-8
class WorkFlowRelateStep < ActiveRecord::Base
  belongs_to :work_flow_step
  belongs_to :work_flow
end
