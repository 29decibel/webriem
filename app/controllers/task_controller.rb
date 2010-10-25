#coding: utf-8
class TaskController < ApplicationController
  def my_docs
    if current_user.person
      redirect_to :controller=>"model_search",:action=>"index",:class_name=>"DocHead",:pre_condition=>"person_id=#{current_user.person.id}",:lookup=>true,:title=>"我的单据"
    else
      @my_docs=[]
    end
  end
  def docs_to_approve
    #我的审批单据，也可以进行过滤，我作为审批角色的单据
    #where("doc_state=1 and work_flow_step_id is not null")
    #.select {|doc| doc.approver.id==current_user.person.id}
    if current_user.person
      if current_user.person.person_type and current_user.person.person_type.code=="CA"
        @docs_to_approve=DocHead.where("doc_state=2 and paid is null")
      else
        @docs_to_approve=DocHead.where("doc_state=1 and work_flow_step_id is not null").select {|doc| doc.approver==current_user.person}
      end
    else
      @docs_to_approve=[]
    end    
  end
end
