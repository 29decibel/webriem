#coding: utf-8
#require "ruby-debug"
require 'prawn/layout'
#借款单—JK  付款单—FK  报销单—BX  收款通知单—SK  结汇申请单—JH  转账申请单—ZH  现金提取申请单—XJ  购买理财产品通知单—GL  赎回理财产品通知单—SL
#9=>"差旅费报销",10=>"交通费报销",11=>"住宿费报销",12=>"工作餐费报销",13=>"加班餐费报销",14=>"加班交通费报销",15=>"业务交通费报销",16=>"福利费用报销"
#DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"交际费报销",11=>"加班费报销",12=>"普通费用报销",13=>"福利费用报销"}
class DocHeadsController < ApplicationController
  #get the current login user and fetch the person info by the user name 
  #and this user name is stored in the person table as person.code
  def current_person
    person=Person.find_by_code(current_user.name)
  end
  # GET /doc_heads
  # GET /doc_heads.xml
  # the entry of all about 's filter and order by
  def index
    #get the specific docs by the doc_type passed by querystring
    #just get all docs of currenct person by test
    @docs = DocHead.where("doc_type=?",params[:doc_type].to_i).all
    @doc_type=params[:doc_type].to_i
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @docs }
    end
  end
  def my_docs
    @docs=DocHead.by_person(current_person.id)
  end

  # GET /doc_heads/1
  # GET /doc_heads/1.xml
  def show
    @doc = DocHead.find(params[:id])
    #if the doc is current needed to be approved by current person,then new a @work_flow_info
    if @doc.processing?
      if @doc.current_approver_id==current_user.person.id
        @work_flow_info=WorkFlowInfo.new
      end
    end
    respond_to do |format|
      format.xml  { render :xml => @doc }
      format.js # show.html.erb
    end
  end

  def edit
    @doc = DocHead.find(params[:id])
    #if the doc is current needed to be approved by current person,then new a @work_flow_info
    if @doc.processing?
      if @doc.current_approver_id==current_user.person.id
        @work_flow_info=WorkFlowInfo.new
      end
    end
  end

  # GET /doc_heads/new
  # GET /doc_heads/new.xml
  def new
    @doc = DocHead.new :doc_type=>params[:doc_type]
    #set the doctype to the paras passed in
    @doc.dep=current_person.dep
    @doc_type = @doc.doc_type
    #set the apply person to the current login user
    @doc.person=current_person
    #build some new doc details
    #if @doc.doc_type==1 or  @doc.doc_type==2
    # @doc.cp_doc_details.build 
    #	cp.dep=current_person.dep
	  #end
    @doc.rec_notice_details.build if @doc.doc_type==3
    reciver=@doc.recivers.build
    #init the reciver's info to current person
    if @doc.doc_type!=2
    	reciver.bank=current_person.bank
    	reciver.bank_no=current_person.bank_no
    	reciver.company=current_person.name
    end
    #build one related stuff
    @doc.build_inner_remittance if @doc.doc_type==4
    @doc.build_inner_transfer if @doc.doc_type==5
    @doc.build_inner_cash_draw if @doc.doc_type==6
    @doc.build_buy_finance_product if @doc.doc_type==7
    @doc.build_redeem_finance_product if @doc.doc_type==8
    #暂时每次都创建一个审批流填写信息
    @doc.work_flow_infos.build
    #set the title
    #render
    #render "edit_doc",:locals=>{:doc=>@doc}
    #respond_to do |format|
    #  format.html # new.html.erb
    #  format.xml  { render :xml => @doc }
    #end
  end


  # POST /doc_heads
  # POST /doc_heads.xml
  def create
    @doc = DocHead.new(params[:doc_head])
    @doc.cp_doc_remain_amount=@doc.total_amount
    #add the offset info
    if params[:offset_info]
      params[:offset_info].each_value do |value|
        @doc.reim_cp_offsets.build(value) if (value["amount"].to_i != 0)
      end
    end
    if @doc.save
      redirect_to doc_head_path(@doc)
    else
      render "new"
    end
  end

  # PUT /doc_heads/1
  # PUT /doc_heads/1.xml
  def update
    #debugger
    @doc = DocHead.find(params[:id])
    #add the offset info
    if params[:offset_info]
      params[:offset_info].each_value do |value|
        @doc.reim_cp_offsets.build(value) if (value["amount"].to_i != 0)
      end
    end
    if @doc.update_attributes(params[:doc_head])
      @doc.update_attribute(:cp_doc_remain_amount,@doc.total_amount)
      @message="#{I18n.t('controller_msg.update_ok')}"
      if @doc.current_approver_id == current_user.person.id
        @work_flow_info=WorkFlowInfo.new
      end
      @doc.reload
    else
      render "edit"
    end
  end

  # DELETE /doc_heads/1
  # DELETE /doc_heads/1.xml
  def destroy
    doc = DocHead.find_by_id params[:id]
    doc.destroy
    redirect_to my_docs_path
  end
  #将单据进入审批阶段
  def submit
    @doc = DocHead.find(params[:doc_id]) 
    if params[:selected_approver_id] and params[:selected_approver_id].first
      @doc.update_attribute :selected_approver_id,params[:selected_approver_id].first
    end
    @doc.submit
    #notice the person who need to approve this doc
    @message="#{I18n.t('controller_msg.start_approve')}"
    if @doc.current_approver_id == current_user.person.id
      @work_flow_info=WorkFlowInfo.new
    end
    respond_to do |format|
      format.js
    end
  end
  #撤销单据的审批
  def recall
  	@doc = DocHead.find(params[:doc_id])
    @doc.recall
  	@message="#{I18n.t('controller_msg.doc_approve_failed')}"
    respond_to do |format|
      format.js
    end
  end
  #付款
  def pay
    #debugger
    @doc=DocHead.find(params[:doc_id].to_i)
    @doc.pay
    #send email
    para={}
    para[:email]=@doc.person.e_mail #person.e_mail  @doc.person.e_mail
    para[:docs_total]=@doc.total_apply_amount
    para[:doc_id]=@doc.id
    #WorkFlowMailer.notice_docs_to_approve para
    Resque.enqueue(MailWorker, :doc_paid,para)
  end
  def approve
    @doc = DocHead.find(params[:id])
    if params[:ok]
      @doc.next_approver params[:comments]
    else
      @doc.decline params[:comments]
    end
  end


  def adjust_amount
    @doc = DocHead.find(params[:id])
    # update fi or hr amount
    item = Kernel.const_get(params['resource_type']).send(:find,params[:resource_id])
    item.adjust_amount :hr_amount,params[:amount]
    respond_to do |wants|
      wants.js
    end
  end

  #batch pay
  def batch_pay
    #get the doc ids and pay it
    params[:doc_ids].split("_").each do |doc_id|
      if !doc_id.blank?
        doc_head=DocHead.find(doc_id.to_i)
        doc_head.pay
        #send email
        para={}
        para[:email]=doc_head.person.e_mail #person.e_mail  @doc.person.e_mail
        para[:docs_total]=doc_head.total_apply_amount
        para[:doc_id]=doc_head.id
        #WorkFlowMailer.notice_docs_to_approve para
        Resque.enqueue(MailWorker, :doc_paid,para)
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
        #增加一个是否是当前审批人的校验
        if current_user.person.id==wf.doc_head.current_approver_id
          if wf.is_ok==1 
            wf.doc_head.approve
            #看看是否符合发邮件的标准 打印
            #send email if hr or fi change the doc amount
            if current_person.person_type and  
              ((current_person.person_type.code=="HR" and wf.doc_head.total_apply_amount!=wf.doc_head.total_hr_amount) or
              (current_person.person_type.code=="FI" and wf.doc_head.total_hr_amount!=wf.doc_head.total_fi_amount))
              para={}
              para[:email]=wf.doc_head.person.e_mail #person.e_mail  @doc.person.e_mail
              para[:docs_total]=wf.doc_head.total_apply_amount
              para[:docs_approve_total]=current_person.person_type.code=="FI" ? wf.doc_head.total_fi_amount : wf.doc_head.total_hr_amount
              para[:doc_id]=wf.doc_head.id
              #WorkFlowMailer.notice_docs_to_approve para
              Resque.enqueue(MailWorker, :amount_change_and_passed,para)
            end
          else
            wf.doc_head.decline
            #send email
            para={}
            para[:email]=wf.doc_head.person.e_mail #person.e_mail  @doc.person.e_mail
            para[:docs_total]=wf.doc_head.total_apply_amount
            para[:doc_id]=wf.doc_head.id
            #WorkFlowMailer.notice_docs_to_approve para
            Resque.enqueue(MailWorker, :doc_not_passed,para)
          end
          wf.doc_head.save
        end #doc's current approver is current person
      end #doc blank
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
    output_str
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
    para[:email]=doc.person.e_mail#person.e_mail  @doc.person.e_mail
    para[:doc_id]=doc.id
    #WorkFlowMailer.notice_docs_to_approve para
    Resque.enqueue(MailWorker, :doc_failed,para)
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
