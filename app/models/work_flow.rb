class WorkFlow < ActiveRecord::Base
  has_many :work_flow_steps, :class_name => "WorkFlowStep", :foreign_key => "work_flow_id"
  accepts_nested_attributes_for :work_flow_steps ,:reject_if => lambda { |a| a[:duty_id].blank? }, :allow_destroy => true
end
