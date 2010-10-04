#coding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!,:except => [:sign_in, :sign_up]
  def get_error_messages(record)
    error_msg=""
    record.errors.full_messages.each do |msg|
      error_msg<<"  #{msg}"
    end
    error_msg
  end
  
  #这个step对应的那个人是谁
  def get_person_from_wfs(work_flow_step,apply_person)
    person=nil
    #不是本部门的直接找
    if work_flow_step.is_self_dep==0
      person=Person.where("dep_id=? and duty_id=?",work_flow_step.dep_id,work_flow_step.duty_id).first
    else
      dep=apply_person.dep
      while dep
        person=Person.where("dep_id=? and duty_id=?",dep.id,work_flow_step.duty_id).first
        break if person
        dep=dep.parent_dep
      end
    end
    person
  end
end
