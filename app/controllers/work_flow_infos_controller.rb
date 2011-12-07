#coding: utf-8
class WorkFlowInfosController < ApplicationController
  before_filter :get_doc
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
    @resource = (@doc_head || @vrv_project)
    logger.info '~~~~~~~~~~~  controller ..............'
    if params["commit"]=='通过'
      logger.info '~~~~~~~~~~~  approve ..............'
      @resource.next_approver params["work_flow_info"]["comments"]
      @resource.reload
    else
      @resource.decline params["work_flow_info"]["comments"]
      @resource.reload
    end
    #redirect_to @doc_head
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
  private
  def get_doc
    @doc_head = DocHead.find_by_id(params[:doc_head_id])
    @vrv_project = VrvProject.find_by_id(params[:vrv_project_id])
  end
end
