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
    else
      @work_flow_info.doc_head.decline
    end
    #send two emails
    #here we change the send email job to a background task
    #WorkFlowMailer.notice_need_approve(@work_flow_info.doc_head.approver,@work_flow_info.doc_head).deliver
    #WorkFlowMailer.notice_aaplyer(@work_flow_info.doc_head.approver,@work_flow_info.doc_head).deliver
    Delayed::Job.enqueue MailingJob.new(:notice_need_approve, @work_flow_info.doc_head.approver,@work_flow_info.doc_head) 
    Delayed::Job.enqueue MailingJob.new(:notice_approver, @work_flow_info.doc_head.approver,@work_flow_info.doc_head) 
    @doc_head=@work_flow_info.doc_head
    if @work_flow_info.save && @doc_head.save
      @message="审批完成"
      @work_flow_info=nil
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@work_flow_info)}
    end
  end

  # PUT /work_flow_infos/1
  # PUT /work_flow_infos/1.xml
  def update
    @work_flow_info = WorkFlowInfo.find(params[:id])
    if @work_flow_info.update_attributes(params[:work_flow_info])
      @message="更新成功"
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
