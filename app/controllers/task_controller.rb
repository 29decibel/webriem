#coding: utf-8
class TaskController < ApplicationController
  def index
    #我的所有单据，可以按照状态进行过滤
    #where("person_id=?",current_user.person.id)
    @my_docs=DocHead.where("person_id=?",current_user.person.id)
    #我的审批单据，也可以进行过滤，我作为审批角色的单据
    #where("doc_state=1 and work_flow_step_id is not null")
    #.select {|doc| doc.approver.id==current_user.person.id}
    @docs_to_approve=DocHead.where("doc_state=1 and work_flow_step_id is not null").select {|doc| doc.approver==current_user.person}
    #@docs_to_approve=docs_to_approve_all.paginate(:page => params[:page], :order => 'created_at DESC')
  end

end
