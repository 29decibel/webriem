#coding: utf-8
require 'prawn/layout'
#require "ruby-debug"
class DocHeadsController < ApplicationController
  before_filter :authenticate_user!
  #get the current login user and fetch the person info by the user name 
  #and this user name is stored in the person table as person.code
  def current_person
    person=Person.find_by_code(current_user.name)
  end
  # GET /doc_heads
  # GET /doc_heads.xml
  # the entry of all about 's filter and order by
  def index
    @search = DocHead.on_board.search(params[:search])
    @doc_heads = params[:search] ?  @search.all : []
    respond_to do |wants|
      wants.js
      wants.html
    end
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
      format.html
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
    @doc = DocHead.new :doc_meta_info=>DocMetaInfo.find(params[:doc_meta_info_id])
    @doc.doc_meta_info.doc_relations.multi(false).each do |dr|
      relation_name = dr.doc_row_meta_info.name.underscore
      if !@doc.send(relation_name)
        @doc.send("build_#{relation_name}")
      end
    end
    @doc.dep=current_person.dep
    @doc.afford_dep=current_person.dep
    @doc.apply_date = Time.now.to_date
    @doc.person=current_person
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
    @docs=DocHead.by_person(current_user.person.id).order('created_at desc').page(params[:page]).per(12)
  end
  #将单据进入审批阶段
  def submit
    @doc = DocHead.find(params[:id]) 
    if @doc.total_amount>0
      if params[:selected_approver_id] and params[:selected_approver_id].first
        @doc.update_attribute :selected_approver_id,params[:selected_approver_id].first
      end
      @doc.submit
      #notice the person who need to approve this doc
      @message="#{I18n.t('controller_msg.start_approve')}"
      if @doc.current_approver_id == current_user.person.id
        @work_flow_info=WorkFlowInfo.new
      end
    end
    respond_to do |format|
      format.js
    end
  end
  #撤销单据的审批
  def recall
  	@doc = DocHead.find(params[:id])
    @doc.recall
  	@message="#{I18n.t('controller_msg.doc_approve_failed')}"
    respond_to do |format|
      format.js
    end
  end
  #付款
  def pay
    #debugger
    @doc=DocHead.find(params[:id])
    @doc.pay
    #send email
    para={}
    para[:email]=@doc.person.e_mail #person.e_mail  @doc.person.e_mail
    para[:docs_total]=@doc.total_amount
    para[:doc_id]=@doc.id
    #WorkFlowMailer.notice_docs_to_approve para
    Resque.enqueue(MailWorker, :doc_paid,para)
  end


  def adjust_amount
    @doc = DocHead.find(params[:id])
    # update fi or hr amount
    item = Kernel.const_get(params['resource_type']).send(:find,params[:resource_id])
    item.adjust_amount "#{current_person.person_type.code.downcase}_amount",params[:amount]
    respond_to do |wants|
      wants.js
    end
  end

  def g_vouch
    @doc = DocHead.find(params[:id])
    @doc.send_vouch_to_u8
    respond_to do |wants|
      wants.js
    end
  end

  def d_vouch
    @doc = DocHead.find(params[:id])
    @doc.destroy_vouch
    respond_to do |wants|
      wants.js
    end
  end

  def generate_ck_doc
    @doc = DocHead.find(params[:id])
    @doc.generate_ck_doc
    redirect_to my_docs_path
    return
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

  #==================================output to txt========================================

  def print_preview
    @doc = DocHead.find(params[:id])
    #if the doc is current needed to be approved by current person,then new a @work_flow_info
    if @doc.processing?
      if @doc.current_approver_id==current_user.person.id
        @work_flow_info=WorkFlowInfo.new
      end
    end
    respond_to do |want|
      want.html {render :show,:layout=>'doc_print'}
    end
  end

  def to_txt_str(docs)
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

  def export_to_txt
    docs = DocHead.scoped
    if params[:scope]
      docs = docs.send(params[:scope])
    end
    if params[:doc_ids]
      docs=docs.where("id in (#{params[:doc_ids]})")
    end
    send_data to_txt_str(docs.all), :filename => "person_accounts.txt",:type => 'text/plain'
  end


  def export_to_xls
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

  def print_pdf
    doc = DocHead.find(params[:id])
    pdf = Prawn::Document.new
    pdf = NormalDoc.to_pdf(pdf,doc)
    send_data(pdf.render, :filename => "#{doc.doc_no}.pdf",:type => "application/pdf")
  end

  def update_invoice_no
    @doc = DocHead.find(params[:doc_id])
    resource_name=eval(params[:resource_name])
    data = resource_name.find_by_id(params[:resource_id])
    if data and data.respond_to?(:invoice_no)
      data.update_attribute :invoice_no,params[:invoice_no]
    end
    render 'show'
  end

end
