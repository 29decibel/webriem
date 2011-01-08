#coding: utf-8
class RefFormController < ApplicationController
  layout "ref_layout"
  CommonRefColumns={
    "Person"=>["name","code",{:name=>"dep__name",:label=>"所在部门"}],
    "Dep"=>["name","code"],
    "Project"=>["name","code"],
    "Currency"=>["name","code","default_rate"]
  }
  FilterColumns=["id","created_at","updated_at"]
  #give you a model name
  def index
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
