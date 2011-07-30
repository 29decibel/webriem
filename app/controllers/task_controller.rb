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
    @docs=DocHead.approved.payable.page(params[:page]).per(20)
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
  # 每个人的dashboard会有所不同
  # 如果是出纳则有一个待付款列表
  # 未审批单据
  # 自己的被审批通过单据
  # 我最近的单据，包括审批中和未提交的
  def dashboard
    @docs_to_pay=DocHead.approved.limit(10)
    @docs_to_approve=DocHead.processing.where("current_approver_id=#{current_user.person.id}").limit(10)
    @my_approved_docs=DocHead.by_person(current_user.person.id).approved.order('created_at desc').limit(10)
    @my_recent_docs = DocHead.by_person(current_user.person.id).un_submit.processing.order('created_at desc').limit(10)
    respond_to do |wants|
      wants.js
      wants.html
      wants.mobile
    end
  end
end
