#coding: utf-8
#require "ruby-debug"
require 'prawn/layout'
#借款单—JK  付款单—FK  报销单—BX  收款通知单—SK  结汇申请单—JH  转账申请单—ZH  现金提取申请单—XJ  购买理财产品通知单—GL  赎回理财产品通知单—SL
#9=>"差旅费报销",10=>"交通费报销",11=>"住宿费报销",12=>"工作餐费报销",13=>"加班餐费报销",14=>"加班交通费报销",15=>"业务交通费报销",16=>"福利费用报销"
#DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"交际费报销",11=>"加班费报销",12=>"普通费用报销",13=>"福利费用报销"}
DOC_TYPE_PREFIX={1=>"JK",2=>"FK",3=>"SK",4=>"JH",5=>"ZH",6=>"XJ",7=>"GL",8=>"SL",9=>"BXCL",10=>"BXJJ",11=>"BXJB",12=>"BXFY",13=>"BXFL"}
class DocHeadsController < ApplicationController
  #get the current login user and fetch the person info by the user name 
  #and this user name is stored in the person table as person.code
  def current_person
    person=Person.find_by_code(current_user.name)
  end
  # GET /doc_heads
  # GET /doc_heads.xml
  def index
    #get the specific docs by the doc_type passed by querystring
    @doc_heads = DocHead.all#where("doc_type=?",params[:doc_type].to_i)
    @doc_type=params[:doc_type].to_i
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @doc_heads }
    end
  end

  # GET /doc_heads/1
  # GET /doc_heads/1.xml
  def show
    @doc_head = DocHead.find(params[:id])
    @doc_type = @doc_head.doc_type
    #if the doc is current needed to be approved by current person,then new a @work_flow_info
    if @doc_head.doc_state==1
      if @doc_head.approver==current_user.person
        @work_flow_info=WorkFlowInfo.new
      end
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @doc_head }
    end
  end

  # GET /doc_heads/new
  # GET /doc_heads/new.xml
  def new
    #set a number to
    doc_count_config=ConfigHelper.find_by_key(:doc_count) || ConfigHelper.create(:key=>"doc_count",:value=>"0") 
    if doc_count_config.value==5000
      doc_count_config.value="0"
    else
      doc_count_config.value=(doc_count_config.value.to_i+1).to_s
    end
    doc_count_config.save
    @doc_head = DocHead.new
    @doc_head.doc_state = 0
    #set the doctype to the paras passed in
    @doc_head.doc_type=params[:doc_type].to_i
    @doc_head.doc_no=DOC_TYPE_PREFIX[@doc_head.doc_type]+Time.now.strftime("%Y%m%d")+doc_count_config.value.rjust(4,"0")
    @doc_head.apply_date=Time.now
    @doc_head.dep=current_person.dep
    @doc_type = @doc_head.doc_type
    #set the apply person to the current login user
    @doc_head.person=current_person
    #build some new doc details
    #if @doc_head.doc_type==1 or  @doc_head.doc_type==2
    #	cp=	@doc_head.cp_doc_details.build 
    #	cp.dep=current_person.dep
	  #end
    @doc_head.rec_notice_details.build if @doc_head.doc_type==3
    reciver=@doc_head.recivers.build
    #init the reciver's info to current person
    if @doc_head.doc_type!=2
    	reciver.bank=current_person.bank
    	reciver.bank_no=current_person.bank_no
    	reciver.company=current_person.name
    end
	reciver.settlement=Settlement.find_by_code("02")
    #build one related stuff
    @doc_head.build_inner_remittance if @doc_head.doc_type==4
    @doc_head.build_inner_transfer if @doc_head.doc_type==5
    @doc_head.build_inner_cash_draw if @doc_head.doc_type==6
    @doc_head.build_buy_finance_product if @doc_head.doc_type==7
    @doc_head.build_redeem_finance_product if @doc_head.doc_type==8
    #暂时每次都创建一个审批流填写信息
    @doc_head.work_flow_infos.build
    #render
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @doc_head }
    end
  end


  # POST /doc_heads
  # POST /doc_heads.xml
  def create
    @doc_head = DocHead.new(params[:doc_head])
    @doc_head.doc_state = 0
    @doc_head.cp_doc_remain_amount=@doc_head.total_apply_amount
    #add the offset info
    if params[:offset_info]
      params[:offset_info].each_value do |value|
        @doc_head.reim_cp_offsets.build(value)
      end
    end
    if @doc_head.save
      @message="#{I18n.t('controller_msg.create_ok')}"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@doc_head)}
    end
  end

  # PUT /doc_heads/1
  # PUT /doc_heads/1.xml
  def update
    @doc_head = DocHead.find(params[:id])
    #add the offset info
    if params[:offset_info]
      params[:offset_info].each_value do |value|
        @doc_head.reim_cp_offsets.build(value)
      end
    end
    if @doc_head.update_attributes(params[:doc_head])
      @doc_head.update_attribute(:cp_doc_remain_amount,@doc_head.total_apply_amount)
      @message="#{I18n.t('controller_msg.update_ok')}"
      if @doc_head.approver==current_user.person
        @work_flow_info=WorkFlowInfo.new
      end
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@doc_head)}
    end
  end

  # DELETE /doc_heads/1
  # DELETE /doc_heads/1.xml
  def destroy
    @doc_head = DocHead.find(params[:id])
    #if @doc_head.doc_state==0
      @doc_head.destroy
      redirect_to(my_docs_url)
    #else
    #  render "shared/errors",:locals=>{:error_msg=>"只有未提交审批的单据可以删除"}
    #end
  end
  #将单据进入审批阶段
  def begin_work
    @doc_head = DocHead.find(params[:doc_id])
    @doc_head.doc_state=1    
    @doc_head.approver_id=params[:approver_id] if !(params[:approver_id]=="-1")
    #找到当前单据类型对应的审批流，然后取第一个流程中的那个step_id
    @doc_head.work_flow_step_id=@doc_head.work_flows.first.id
    @doc_head.save
    #notice the person who need to approve this doc
    #WorkFlowMailer.notice_need_approve(@doc_head.approver,@doc_head).deliver
    #now i am using the delayed job to do this
    #Delayed::Job.enqueue MailingJob.new(:notice_need_approve, @doc_head.approver,@doc_head) 
    @message="#{I18n.t('controller_msg.start_approve')}"
    if @doc_head.approver==current_user.person
      @work_flow_info=WorkFlowInfo.new
    end
    respond_to do |format|
      format.js { render "shared/show_result"}
    end
  end
  #撤销单据的审批
  def giveup
  	@doc_head = DocHead.find(params[:doc_id])
  	@doc_head.doc_state=0
  	@doc_head.approver_id=nil
  	@doc_head.work_flow_step_id=nil
  	@doc_head.save
  	@message="#{I18n.t('controller_msg.doc_approve_failed')}"
    respond_to do |format|
      format.js { render "shared/show_result"}
    end
  end
  #付款
  def pay
    #debugger
    @doc_head=DocHead.find(params[:doc_id].to_i)
    @doc_head.update_attribute(:doc_state,3)
    #send email
    para={}
    para[:email]=@doc_head.person.e_mail #person.e_mail  @doc_head.person.e_mail
    para[:docs_total]=@doc_head.total_apply_amount
    para[:doc_id]=@doc_head.id
    #WorkFlowMailer.notice_docs_to_approve para
    Delayed::Job.enqueue MailingJob.new(:doc_paid, para)
    #debugger
    @message="#{I18n.t('controller_msg.pay_ok')}"
    render "shared/show_result"
  end
  #batch pay
  def batch_pay
    #get the doc ids and pay it
    params[:doc_ids].split("_").each do |doc_id|
      if !doc_id.blank?
        doc_head=DocHead.find(doc_id.to_i)
        doc_head.update_attribute(:doc_state,3)
        #send email
        para={}
        para[:email]=doc_head.person.e_mail #person.e_mail  @doc_head.person.e_mail
        para[:docs_total]=doc_head.total_apply_amount
        para[:doc_id]=doc_head.id
        #WorkFlowMailer.notice_docs_to_approve para
        Delayed::Job.enqueue MailingJob.new(:doc_paid, para)
      end
    end
    render :json=>"#{I18n.t('controller_msg.batch_pay_ok')}"
    #redirect_to :controller=>:tasks,:action=>:docs_to_pay,:notice=>"批量付款成功",:status => 301
  end
  #batch approve docs
  def batch_approve
    #create a work_flow
    params[:doc_ids].split("_").each do |doc_id|
      if !doc_id.blank?
        wf=WorkFlowInfo.create(:is_ok=>params[:is_ok]=="true",:comments=>params[:comments],:doc_head_id=>doc_id,:people_id=>current_user.person.id)
        if wf.is_ok==1
          wf.doc_head.next_work_flow_step
          #看看是否符合发邮件的标准 打印
          #send email if hr or fi change the doc amount
          if current_person.person_type and  
            ((current_person.person_type.code=="HR" and wf.doc_head.total_apply_amount!=wf.doc_head.total_hr_amount) or
            (current_person.person_type.code=="FI" and wf.doc_head.total_hr_amount!=wf.doc_head.total_fi_amount))
            para={}
            para[:email]=wf.doc_head.person.e_mail #person.e_mail  @doc_head.person.e_mail
            para[:docs_total]=wf.doc_head.total_apply_amount
            para[:docs_approve_total]=current_person.person_type.code=="FI" ? wf.doc_head.total_fi_amount : wf.doc_head.total_hr_amount
            para[:doc_id]=wf.doc_head.id
            #WorkFlowMailer.notice_docs_to_approve para
            Delayed::Job.enqueue MailingJob.new(:amount_change_and_passed, para)
          end
        else
          wf.doc_head.decline
          #send email
          para={}
          para[:email]=wf.doc_head.person.e_mail #person.e_mail  @doc_head.person.e_mail
          para[:docs_total]=wf.doc_head.total_apply_amount
          para[:doc_id]=wf.doc_head.id
          #WorkFlowMailer.notice_docs_to_approve para
          Delayed::Job.enqueue MailingJob.new(:doc_not_passed, para)
        end
        wf.doc_head.save
      end
    end
    render :json=>"#{I18n.t('controller_msg.batch_approve_ok')}"
    #redirect_to :controller=>:tasks,:action=>:docs_to_approve,:notice=>"批量审批完成",:status => 301
  end
  #print goes here
  def print
    doc=DocHead.find(params[:doc_id])
    pdf=nil      
    pdf=case doc.doc_type
      when 1 then JkPdf.new
      when 2 then FkPdf.new
      when 3 then SktzPdf.new
      when 4 then JhPdf.new
      when 5 then ZzPdf.new
      when 6 then XjtqPdf.new
      when 7 then GmlcPdf.new
      when 8 then ShlcPdf.new
      when 9 then ClPdf.new
      when 10 then JjPdf.new
      when 11 then JbfPdf.new
      when 12 then PtfyPdf.new
      else FlfyPdf.new
    end
    pdf.doc=doc
    send_data pdf.to_pdf, :filename => "hello.pdf",:type => "application/pdf"
  end
  #==================================output to txt========================================
  def output_to_txt
    #send_data Person.first, :filename => "hello.txt",:type => "application/txt"
    @recivers=[]
    params[:ids].split('_').each do |id|
      doc_head=DocHead.find_by_id(id)
      send_data "aaaaggggg",:filename=>"accountsInfo.txt",:type=>"application/txt"
      #if doc_head
      #  doc_head.recivers.each do |r|
      #    @recivers<<{:bank_no=>r.bank_no,:name=>r.company,:amount=>r.amount}
      #  end
      #end
    end
  end
  def doc_failed
    doc=DocHead.find(params[:doc_id])
    @message="#{I18n.t('controller_msg.message_sent')}"
    #send email
    para={}
    para[:email]=doc.person.e_mail#person.e_mail  @doc_head.person.e_mail
    para[:doc_id]=doc.id
    #WorkFlowMailer.notice_docs_to_approve para
    Delayed::Job.enqueue MailingJob.new(:doc_failed, para)
    respond_to do |format|
      format.js { render "shared/show_result"}
    end
  end
end
