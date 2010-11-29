#coding: utf-8
require 'time'
class PriTaskController < ApplicationController
  #delete all docs
  def clear_doc
    @message="#{DocHead.count}个单据被清除"
    DocHead.delete_all
  end
  #reset all doc state
  def reset_doc_state
    DocHead.all.each do |d|
      if ![1,2,3].include? d.doc_state
        d.doc_state=3
      end
    end
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
  def import_cps
    File.open("#{RAILS_ROOT}/doc/pre_cps.txt").each_line do |line|
      #get doc number
      doc_count_config=ConfigHelper.find_by_key(:doc_count) || ConfigHelper.create(:key=>"doc_count",:value=>"0")
      person=Person.find_by_code(line.split(' ')[2].strip)
      dep=Dep.find_by_code(line.split(' ')[0].strip)
      doc_head=DocHead.new
      doc_head.doc_state = 0
      #set the doctype to the paras passed in
      doc_head.doc_type=1
      that_time=Time.parse(line.split(' ')[4].strip)
      doc_head.doc_no=DOC_TYPE_PREFIX[1]+that_time.strftime("%Y%m%d")+doc_count_config.value.rjust(4,"0")
      doc_head.apply_date=that_time
      doc_head.dep=dep
      doc_head.person=person
      #build some new doc details
      #if @doc_head.doc_type==1 or  @doc_head.doc_type==2
      cp=	doc_head.cp_doc_details.build 
      cp.dep=dep
      cp.currency=Currency.find_by_code('RMB')
      cp.rate=1
      cp.ori_amount=line.split(' ')[5].strip.to_f
      cp.apply_amount=line.split(' ')[5].strip.to_f
      cp.used_for=line.split(' ')[6].strip.to_f
	    #end
      reciver=doc_head.recivers.build
      #init the reciver's info to current person
      reciver.bank=person.bank
      reciver.bank_no=person.bank_no
      reciver.company=person.name
      reciver.direction=0	
	    reciver.settlement=Settlement.find_by_code("02")
      doc_head.save
    end
  end
end
