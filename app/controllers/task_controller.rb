#coding: utf-8
class TaskController < ApplicationController
  def my_docs
    if current_user.person
      redirect_to :controller=>"model_search",:action=>"index",:class_name=>"DocHead",:pre_condition=>"person_id=#{current_user.person.id}",:lookup=>true,:title=>"我的单据",:layout=>true,:outputable=>true,:printable=>true,:user_display_columns=>:my_doc_display_columns
    else
      render "task/no_rights_error"
    end
  end
  #docs need to approve
  def docs_to_approve
    if current_user.person
      redirect_to :controller=>"model_search",:action=>"index",:class_name=>"DocHead",:pre_condition=>"doc_state=1 and work_flow_step_id is not null",:filter_method=>"docs_to_approve",:lookup=>true,:title=>"需要审批的单据",:multicheck=>true,:checkable=>true,:batch_approve=>true,:layout=>true,:outputable=>true,:printable=>true,:user_display_columns=>:doc_to_approve_display_columns 
    else
      render "task/no_rights_error"
    end  
  end
  #the docs need to pay
  def docs_to_pay
    if current_user.person and current_user.person.person_type and current_user.person.person_type.code=="CA"
      redirect_to :controller=>"model_search",:action=>"index",:class_name=>"DocHead",:pre_condition=>"doc_state=2 and paid is null",:lookup=>true,:title=>"需要付款的单据",:multicheck=>true,:checkable=>true,:batch_pay=>true,:layout=>true,:outputable=>true,:printable=>true
    else
      render "task/no_rights_error"
    end
  end
  #the docs that has been approved
  def docs_approved
    if current_user.person
      redirect_to :controller=>"model_search",:action=>"index",:class_name=>"DocHead",:joins=>"work_flow_infos",:pre_condition=>"work_flow_infos.people_id=#{current_user.person.id}",:lookup=>true,:title=>"审批过的单据",:layout=>true,:outputable=>true,:printable=>true
    else
      render "task/no_rights_error"
    end
  end
  #docs already paid
  def docs_paid
    if current_user.person
      redirect_to :controller=>"model_search",:action=>"index",:class_name=>"DocHead",:pre_condition=>"doc_state=2 and paid=1",:lookup=>true,:title=>"已经付款的单据",:layout=>true,:outputable=>true,:printable=>true
    else
      render "task/no_rights_error"
    end
  end
  def import
    @errors=[]
    
  end
	#
  def private_cmd
  	PersonType.create(:name=>"MTA",:code=>"MTA")
	  PersonType.create(:name=>"管理担当",:code=>"MN")
  end
end
