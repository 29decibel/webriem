#coding: utf-8
class ExtraWorkStandard < ActiveRecord::Base
  def custom_display(column)
    column_name=column.class==String ? column:column.name
    if column_name=="is_sunday"
      return is_sunday ? "是" : "否"
    end
  end
  def self.custom_select(results,column_name,filter_text)
  	if column_name=="is_sunday"
    	results.select {|es| es.custom_display.include? filter_text}
	  else
		  results
	  end
  end
end
