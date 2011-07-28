#coding: utf-8
class WorkFlowInfosController < ApplicationController
  # GET /work_flow_infos
  # GET /work_flow_infos.xml
  layout false
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
    @doc = DocHead.find(params[:doc_id])
    @work_flow_info = WorkFlowInfo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @work_flow_info }
    end
  end

  # POST /work_flow_infos
  # POST /work_flow_infos.xml
  def create
    @doc = DocHead.find(params[:doc_id])
    if params["work_flow_info"]["is_ok"] =='true'
      @doc.next_approver params["work_flow_info"]["comments"]
      @doc.reload
    else
      @doc.decline params["work_flow_info"]["comments"]
      @doc.reload
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
