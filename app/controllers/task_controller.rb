#coding: utf-8
class TaskController < ApplicationController
  def my_docs
    @docs=DocHead.by_person(current_user.person.id)
    respond_to do |format|
      format.js { render 'show_docs'}
    end
  end
  #docs need to approve
  def docs_to_approve
    @docs=DocHead.by_person(current_user.person.id)
    respond_to do |format|
      format.js { render 'show_docs'}
    end
  end
  #the docs need to pay
  def docs_to_pay
    @docs=DocHead.by_person(current_user.person.id)
    respond_to do |format|
      format.js { render 'show_docs'}
    end
  end
  #the docs that has been approved
  def docs_approved
    @docs=DocHead.by_person(current_user.person.id)
    respond_to do |format|
      format.js { render 'show_docs'}
    end
  end
  #docs already paid
  def docs_paid
    @docs=DocHead.by_person(current_user.person.id)
    respond_to do |format|
      format.js { render 'show_docs'}
    end
  end
end
