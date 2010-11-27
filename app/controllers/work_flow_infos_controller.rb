#coding: utf-8
class WorkFlowInfosController < ApplicationController
  # GET /work_flow_infos
  # GET /work_flow_infos.xml
  def index
    @work_flow_infos = WorkFlowInfo.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @work_flow_infos }
    end
  end

  # GET /work_flow_infos/1
  # GET /work_flow_infos/1.xml
  def show
    @work_flow_info = WorkFlowInfo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @work_flow_info }
    end
  end

  # GET /work_flow_infos/new
  # GET /work_flow_infos/new.xml
  def new
    @work_flow_info = WorkFlowInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @work_flow_info }
    end
  end

  # POST /work_flow_infos
  # POST /work_flow_infos.xml
  def create
    @work_flow_info = WorkFlowInfo.new(params[:work_flow_info])
    if @work_flow_info.is_ok==1
      @work_flow_info.doc_head.next_work_flow_step
      #send email if hr or fi change the doc amount
      doc_head=@work_flow_info.doc_head
      if current_user.person.person_type and  
        ((current_user.person.person_type.code=="HR" and doc_head.total_apply_amount!=doc_head.total_hr_amount) or
        (current_user.person.person_type.code=="FI" and doc_head.total_hr_amount!=doc_head.total_fi_amount))
        para={}
        para[:email]=doc_head.person.e_mail #person.e_mail  @doc_head.person.e_mail
        para[:docs_total]=doc_head.total_apply_amount
        para[:docs_approve_total]=current_user.person.person_type.code=="FI" ? doc_head.total_fi_amount : doc_head.total_hr_amount
        para[:doc_id]=doc_head.id
        #WorkFlowMailer.notice_docs_to_approve para
        Delayed::Job.enqueue MailingJob.new(:amount_change_and_passed, para)
      end
    else
      @work_flow_info.doc_head.decline
      #send email
      para={}
      para[:docs_total]=@work_flow_info.doc_head.total_apply_amount
      para[:doc_id]=@work_flow_info.doc_head.id
      para[:email]=@work_flow_info.doc_head.person.e_mail #person.e_mail  @doc_head.person.e_mail
      #WorkFlowMailer.notice_docs_to_approve para
      Delayed::Job.enqueue MailingJob.new(:doc_not_passed, para)
    end
    #send two emails
    @doc_head=@work_flow_info.doc_head
    if @work_flow_info.valid? and @doc_head.valid?
      @work_flow_info.save && @doc_head.save
      @message="#{I18n.t('controller_msg.approve_ok')}"
      @work_flow_info=nil
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@work_flow_info)+get_error_messages(@doc_head)}
    end
  end

  # PUT /work_flow_infos/1
  # PUT /work_flow_infos/1.xml
  def update
    @work_flow_info = WorkFlowInfo.find(params[:id])
    if @work_flow_info.update_attributes(params[:work_flow_info])
      @message="#{I18n.t('controller_msg.update_ok')}"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@work_flow_info)}
    end
  end

  # DELETE /work_flow_infos/1
  # DELETE /work_flow_infos/1.xml
  def destroy
    @work_flow_info = WorkFlowInfo.find(params[:id])
    @work_flow_info.destroy

    respond_to do |format|
      format.html { redirect_to(work_flow_infos_url) }
      format.xml  { head :ok }
    end
  end
end
