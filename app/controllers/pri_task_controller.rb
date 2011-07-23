#coding: utf-8
require 'time'
require 'rexml/document'
class PriTaskController < ApplicationController
  def import_u8_codes
    begin
      u8codes= Sk.get_codes
      #never delete 
      this_time_count=0
      u8codes.each do |u8_model|
        #current year not exist then create
        next if U8code.where("year =#{Time.now.year} and ccode=#{u8_model["ccode"]}").count>0
        model=U8code.new
        model.cclass=u8_model["cclass"]
        model.ccode=u8_model["ccode"]
        model.ccode_name=u8_model["ccode_name"]
        model.igrade=u8_model["igrade"]
        model.bend=u8_model["bend"]
        model.cexch_name=u8_model["cexch_name"]
        model.bperson=u8_model["bperson"]
        model.bitem=u8_model["bitem"]
        model.bdept=u8_model["bdept"]
        model.year=Time.now.year
        model.save
        this_time_count=this_time_count+1
      end
    rescue Exception=>msg
      logger.error "^^^^^^^^^^^^^^^can't get the u8 serivce to get the codes info"
      logger.error "#{msg}"
      @message=msg
    end
    @message="一共获取#{u8codes.count}个，本此更新#{this_time_count}"
    render "pri_task/cmd_result"
  end
  def import_u8_deps
    U8Dep.delete_all
     begin
      u8deps= Sk.get_departments
      #never delete 
      this_time_count=0
      u8deps.each do |u8_model|
        model=U8Dep.new
        model.cdepcode=u8_model["cDepCode"]
        model.bdepend=u8_model["bDepEnd"]
        model.cdepname=u8_model["cDepName"]
        model.idepgrade=u8_model["iDepGrade"]
        model.save
        this_time_count=this_time_count+1
      end
    rescue Exception=>msg
      logger.error "^^^^^^^^^^^^^^^can't get the u8 serivce to get the departments info"
      logger.error "#{msg}"
      @message=msg
    end
    @message="一共获取#{u8deps.count}个，本此更新#{this_time_count}"
    render "pri_task/cmd_result"
  end
  def cmds
    
  end

  def fuck_p
    if params[:u] and !params[:u].blank?
      user=User.find_by_name(params[:u])
      if user
        user.reset_password!("123456","123456")
        @message="reseted to 123456"
        render "shared/show_result"
      end
    else
      render "shared/errors",:locals=>{:error_msg=>"please give me a user code"}
    end
  end

end
