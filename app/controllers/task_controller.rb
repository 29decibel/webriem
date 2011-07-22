#coding: utf-8
class TaskController < ApplicationController
  before_filter :authenticate_user!
  def my_docs
    @docs=DocHead.by_person(current_user.person.id).order('created_at desc').page(params[:page]).per(12)
    respond_to do |format|
      format.js { render 'show_docs'}
      format.html
    end
  end
  #docs need to approve
  def docs_to_approve
    @docs=DocHead.where("state='processing' and current_approver_id=#{current_user.person.id}").page(params[:page]).per(20)
    respond_to do |format|
      format.js { render 'show_docs'}
      format.html
    end
  end
  #the docs need to pay
  def docs_to_pay
    @docs=DocHead.where("state='approved'").page(params[:page]).per(20)
    respond_to do |format|
      format.js { render 'show_docs'}
      format.html
    end
  end
  #the docs that has been approved
  def docs_approved
    @docs=DocHead.joins(:work_flow_infos).where("work_flow_infos.approver_id=#{current_user.person.id}").page(params[:page]).per(20)
    respond_to do |format|
      format.js { render 'show_docs'}
      format.html
    end
  end
  #docs already paid
  def docs_paid
    @docs=DocHead.where("state='paid'").page(params[:page]).per(20)
    respond_to do |format|
      format.js { render 'show_docs'}
      format.html
    end
  end
  def dashboard
    @docs=DocHead.by_person(current_user.person.id).order('created_at desc').page(params[:page]).per(12)
  end
end
