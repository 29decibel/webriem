#coding: utf-8
class RefFormController < ApplicationController
  layout "ref_layout"
  CommonRefColumns={
    "Person"=>["name","code",{:name=>"dep__name",:label=>"所在部门"}],
    "Dep"=>["name","code"],
    "Project"=>["name","code"],
    "Fee"=>["name","code"],
    "Currency"=>["name","code","default_rate"]
  }
  FilterColumns=["id","created_at","updated_at"]
  #custom where strings
  def custom_where_string(model_name)
    str=" status=0 "
    #if the dep model should see the current version
    if model_name=="Dep"
      current_dep_version = SystemConfig.find_by_key("dep_version")
      if current_dep_version and current_dep_version.value
        str= str + " and version='#{current_dep_version.value}'" 
      end
    end
    #filter person is leaving
    if model_name=="Person"
      str=str+" and (people.end_date is null or people.end_date > '#{Time.now}')"
    end
    #filter u8code current year
    if model_name=="U8code"
      str=str+" and year=#{Time.now.year}"
    end
    #filter fee
    if model_name=="Fee"
      str=str+" and show_in_ref=1"
    end
    #filter closed project
    if model_name=="Project"
      str=str+" and status=0"
    end
    str
  end
  #give you a model name
  def index
    @where_str=custom_where_string(params[:class_name])
    @model_name = params[:class_name]
    @multiselect = params[:multicheck] || false #pre_condition    
    @colModel = common_ref_columns(@model_name)
  end
  def common_ref_columns(model_name)
    cols=[]
    if CommonRefColumns[model_name]
      cols=CommonRefColumns[model_name]
    else
      cols=eval(model_name).column_names.select {|c| !(FilterColumns.include?(c))}
    end
    #add additional info
    cols<<{:name=>"id",:hidden=>true}
    cols<<{:name=>"hidden_display",:getter=>"to_s",:hidden=>true}
    cols<<{:name=>"other_info",:getter=>"other_info",:hidden=>true}
    #return
    cols
  end

end
