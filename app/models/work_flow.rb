class WorkFlow < ActiveRecord::Base
  include ApplicationHelper
  has_many :work_flow_steps, :class_name => "WorkFlowStep", :foreign_key => "work_flow_id"
  has_and_belongs_to_many :duties
  accepts_nested_attributes_for :work_flow_steps ,:reject_if => lambda { |a| a[:duty_id].blank? }, :allow_destroy => true
  def custom_display(column)
    column_name=column.class==String ? column:column.name
    if column_name=="doc_types"
      doc_type_names_a=doc_types.split(';').map {|d_t| DOC_TYPES[d_t.to_i]}
      doc_type_names_a.join(",")
    end
  end
  def self.custom_select(results,column_name,filter_text)
  	if column_name=="doc_types"
    	results.select {|work_flow| work_flow.custom_display("doc_types").include? filter_text}
    else
    	results
	end
  end
end
