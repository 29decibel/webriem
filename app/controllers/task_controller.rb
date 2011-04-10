#coding: utf-8
class TaskController < ApplicationController
  def my_docs
    @docs=DocHead.by_person(current_user.person.id).page(params[:page]).per(20)
    respond_to do |format|
      format.js { render 'show_docs'}
    end
  end
  #docs need to approve
  def docs_to_approve
    @docs=DocHead.where("doc_state=1 and current_approver_id=#{current_user.person.id}").page(params[:page]).per(20)
    respond_to do |format|
      format.js { render 'show_docs'}
    end
  end
  #the docs need to pay
  def docs_to_pay
    @docs=DocHead.where("doc_state=2").page(params[:page]).per(20)
    respond_to do |format|
      format.js { render 'show_docs'}
    end
  end
  #the docs that has been approved
  def docs_approved
    @docs=DocHead.joins(:work_flow_infos).where("work_flow_infos.people_id=#{current_user.person.id}").page(params[:page]).per(20)
    respond_to do |format|
      format.js { render 'show_docs'}
    end
  end
  #docs already paid
  def docs_paid
    @docs=DocHead.where("doc_state=3").page(params[:page]).per(20)
    respond_to do |format|
      format.js { render 'show_docs'}
    end
  end
  def dashboard
    @docs=DocHead.by_person(current_user.person.id).page(params[:page]).per(5)
  end
end
