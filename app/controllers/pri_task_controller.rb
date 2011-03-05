#coding: utf-8
require 'time'
require 'rexml/document'
require 'api'
require File.join(Rails.root, 'app', 'u8service','api.rb')
class PriTaskController < ApplicationController
  def import_u8_codes
    begin
      u8codes= U8service::API.get_codes
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
      u8deps= U8service::API.get_departments
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
  #reset password
  def reset_pw
    user=params[:user]
    #
  end
  def adapt_menu
    #DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"交际费报销",11=>"加班费报销",12=>"普通费用报销",13=>"福利费用报销"}
    doc_name_enum = {1=>"d_Borrow",2=>"d_PayDoc",3=>"d_ReciveNotice",4=>"d_Redeem",5=>"d_Transfer",6=>"d_CashDraw",7=>"d_BuyFinanceProduct",8=>"d_RedeemFinanceProduct",9=>"d_TravelExpense",10=>"d_EntertainmentExpense",11=>"d_OvertimeWork",12=>"d_GeneralExpense",13=>"d_Wage"}
    count=0
    (1..13).each do |num|
      m=Menu.find_by_name(num.to_s)
      if m
        m.name=doc_name_enum[num]
        count=count+1
        m.save
      end
    end
    @message="#{count}个菜单被重命名"
    render "pri_task/cmd_result"
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
  def fuck_date
    doc=DocHead.find(385)
    doc.rd_extra_work_meals.each do |w_m|
      w_m.update_attribute(:start_time,Time.now)
      w_m.update_attribute(:end_time,Time.now)
    end
  end
  def import_project
    url="http://gpm.skcc.com/services/ServiceFacade/getAllProjectsInformationFromGPM.do"
    url_content= Net::HTTP.get(URI.parse(url))
    #xml=REXML::Document.new(url_content)
    @message=url_content.to_s
    render "pri_task/cmd_result"
  end
  def import_person
    url="http://10.120.108.97:7001/services/ServiceFacade/GetEmployeeInformations.do"
    url_content= Net::HTTP.get(URI.parse(url))
    #xml=REXML::Document.new(url_content)
    puts url_content
    @message=url_content.to_s
    render "pri_task/cmd_result"
  end
  def test_curb    
    @message=U8service::API.get_departments
    JSON(@message).each do |u8dep|
      d=U8Dep.new(u8dep)
      d.save
    end
    render "pri_task/cmd_result"
  end
end
