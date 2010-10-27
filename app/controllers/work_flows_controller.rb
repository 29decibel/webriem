#coding: utf-8
#require "ruby-debug"
class WorkFlowsController < ApplicationController
  # GET /work_flows
  # GET /work_flows.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"WorkFlow",:lookup=>true,:addable=>true,:deletable=>true
  end

  # GET /work_flows/1
  # GET /work_flows/1.xml
  def show
    @work_flow = WorkFlow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @work_flow }
    end
  end

  # GET /work_flows/new
  # GET /work_flows/new.xml
  def new
    @work_flow = WorkFlow.new
    @work_flow.doc_types="0"
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @work_flow }
    end
  end


  # POST /work_flows
  # POST /work_flows.xml
  def create
    @work_flow = WorkFlow.new(params[:work_flow])
    update_doc_types(params[:doc_types])
    #debugger
    if @work_flow.save
      @message="创建成功"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@work_flow)}
    end
  end
  
  def update_doc_types(doc_type_array)
    @work_flow.doc_types=doc_type_array.join(';')
  end

  # PUT /work_flows/1
  # PUT /work_flows/1.xml
  def update
    @work_flow = WorkFlow.find(params[:id])
    update_doc_types(params[:doc_types])
    if @work_flow.update_attributes(params[:work_flow])
      @message="更新成功"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@work_flow)}
    end
  end

  # DELETE /work_flows/1
  # DELETE /work_flows/1.xml
  def destroy
    @work_flow = WorkFlow.find(params[:id])
    @work_flow.destroy

    respond_to do |format|
      format.html { redirect_to(work_flows_url) }
      format.xml  { head :ok }
    end
  end
end
