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
    set_doc_info_4_budget
    #if the doc is current needed to be approved by current person,then new a @work_flow_info
    if @doc_head.doc_state==1
      if @doc_head.current_approver_id==current_user.person.id
        @work_flow_info=WorkFlowInfo.new
      end
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @doc_head }
    end
  end
  def set_doc_info_4_budget
    @doc_type = @doc_head.doc_type
    #show the budget info
    @b_project_id=@doc_head.project_id
    @b_fee_id=@doc_head.budget_fee_id
    @b_dep_id=@doc_head.afford_dep_id
    @b_year=@doc_head.apply_date.year
    @doc_id=@doc_head.id
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
	  set_doc_info_4_budget
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
    #debugger
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
      if @doc_head.current_approver_id == current_user.person.id
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
    #here i will get a lot of ids
    DocHead.where("id in (#{params[:doc_ids]})").each do |doc_head|
      doc_head.destroy
    end
    render :json=>"ok"
  end
  #将单据进入审批阶段
  def begin_work
    @doc_head = DocHead.find(params[:doc_id]) 
    approver_id=params[:approver_id] if !(params[:approver_id]=="-1")
    #begin approver
    @doc_head.begin_approve(approver_id)
    @doc_head.save
    #notice the person who need to approve this doc
    @message="#{I18n.t('controller_msg.start_approve')}"
    if @doc_head.current_approver_id == current_user.person.id
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
          wf.doc_head.approve
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
    pdf=Prawn::Document.new
    pdf=to_pdf(pdf,doc)
    send_data pdf.render, :filename => "hello.pdf",:type => "application/pdf"
  end
  def batch_print
    pdf=Prawn::Document.new
    #get the doc ids and pay it
    params[:doc_ids].split("_").each_with_index do |doc_id,index|
      if !doc_id.blank?
        doc=DocHead.find(doc_id.to_i)
        pdf=to_pdf(pdf,doc)
        pdf.start_new_page if index!=params[:doc_ids].split("_").count-1
      end
    end
    #debugger
    #pdf.number_pages "第<page>页 共<total>页", [pdf.bounds.right - 50, 0]
     #pdf.page_count.times do |i|
     #  pdf.go_to_page(i+1)
     #  pdf.lazy_bounding_box([pdf.bounds.right-50, pdf.bounds.bottom + 25], :width => 50) {
     #    pdf.text "#{i+1} / #{page_count}"
     #  }.draw
     #end
    send_data pdf.render, :filename => "hello.pdf",:type => "application/pdf"
  end
  #==================================output to txt========================================
  def output_to_txt_all
    docs=DocHead.where("doc_state=2").all
    #just redirect to output_to_txt
    send_data docs_to_txt(docs), :filename => "person_accounts.txt",:type => 'text/plain'
  end
  def docs_to_txt(docs)
    #get these docs's reciver amount and return a string
    output_str=""
    #reciver's hash`
    recivers={}
    docs.each do |doc_head|
      if doc_head and doc_head.doc_type!=2
        doc_head.recivers.each_with_index do |r,index|
          next if r.amount==0
          if recivers.has_key? r.company
            recivers[r.company][:amount]=recivers[r.company][:amount]+(r.fi_amount||r.amount)
          else
            recivers[r.company]={:bank_no=>r.bank_no,:amount=>(r.fi_amount||r.amount)}
          end
        end
      end
    end
    #print
    count=1
    recivers.each_pair do |key,value|
      output_str<<count.to_s.rjust(7,"0")
      output_str<<"|"
      output_str<<value[:bank_no]
      output_str<<"|"
      output_str<<key
      output_str<<"|"
      output_str<<value[:amount].to_s
      output_str<<"|00110|1122|"
      output_str<<"\r\n"
      count=count+1
    end
  end
  def output_to_txt
    docs=DocHead.where("id in (#{params[:ids]})").all
    send_data docs_to_txt(docs), :filename => "person_accounts.txt",:type => 'text/plain'
  end
  def export_xls
    ids=params[:ids]
    @docs=[]
    DocHead.where("id in (#{ids})").each do |doc|
      if doc.doc_type==12
        @docs<<[doc.doc_no,doc.person.name,"#{doc.doc_type_name}(业务交通费)",doc.amount_for(:rd_common_transports).to_s] if doc.rd_common_transports.count>0
        @docs<<[doc.doc_no,doc.person.name,"#{doc.doc_type_name}(工作餐费)",doc.amount_for(:rd_work_meals).to_s] if doc.rd_work_meals.count>0
      else
        @docs<<[doc.doc_no,doc.person.name,doc.doc_type_name,doc.total_amount.to_s]
      end
    end
    respond_to do |format|
      format.xls
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
  def mark
    ids=params[:doc_ids]
    mark_info=params[:mark]
    ids.split(",").each do |id|
      doc=DocHead.find_by_id(id)
      if doc
        doc.update_attribute(:mark,mark_info)
      end
    end
    render :json=>"ok"
  end
  private
  def to_pdf(pdf,doc)
    pdf=case doc.doc_type
      when 1 then JkPdf.to_pdf(pdf,doc)
      when 2 then FkPdf.to_pdf(pdf,doc)
      when 3 then SktzPdf.to_pdf(pdf,doc)
      when 4 then JhPdf.to_pdf(pdf,doc)
      when 5 then ZzPdf.to_pdf(pdf,doc)
      when 6 then XjtqPdf.to_pdf(pdf,doc)
      when 7 then GmlcPdf.to_pdf(pdf,doc)
      when 8 then ShlcPdf.to_pdf(pdf,doc)
      when 9 then ClPdf.to_pdf(pdf,doc)
      when 10 then JjPdf.to_pdf(pdf,doc)
      when 11 then JbfPdf.to_pdf(pdf,doc)
      when 12 then PtfyPdf.to_pdf(pdf,doc)
      else FlfyPdf.to_pdf(pdf,doc)
    end
  end
end
