#coding: utf-8
class TaskController < ApplicationController
  def my_docs
    render "task/no_rights_error" unless current_user.person
  end
  #docs need to approve
  def docs_to_approve
    render "task/no_rights_error" unless current_user.person
  end
  #the docs need to pay
  def docs_to_pay
    render "task/no_rights_error" unless current_user.person 
  end
  #the docs that has been approved
  def docs_approved
    render "task/no_rights_error" unless current_user.person
  end
  #docs already paid
  def docs_paid
    render "task/no_rights_error" unless current_user.person
  end
end
