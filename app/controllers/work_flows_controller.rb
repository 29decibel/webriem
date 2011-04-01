#coding: utf-8
#require "ruby-debug"
class WorkFlowsController < ApplicationController
  # GET /work_flows
  # GET /work_flows.xml
  def index
    @resources=WorkFlow.page(params[:page]).per(20)
    @model_s_name="work_flow"
    @model_p_name="work_flows"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  def edit
    @work_flow  = WorkFlow.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@work_flow  }}
    end  
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
      format.js { render "basic_setting/new",:locals=>{:resource=>@work_flow }}
    end
  end


  # POST /work_flows
  # POST /work_flows.xml
  def create
    @work_flow = WorkFlow.new(params[:work_flow])
    update_doc_types(params[:doc_types])
    #set the person have such a role
    params[:duty_ids].split('_').each do |duty_id|
      @work_flow.duties<<Duty.find(duty_id.to_i)
    end
    #debugger
    if !@work_flow .save
      render "basic_setting/new",:locals=>{:resource=>@work_flow  }
    else
      redirect_to work_flows_path
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
    #set the person have such a role
    @work_flow.duties.clear
    params[:duty_ids].split('_').each do |duty_id|
      @work_flow.duties<<Duty.find(duty_id.to_i)
    end
    if !@work_flow.update_attributes(params[:work_flow])
      render "basic_setting/edit",:locals=>{:resource=>@work_flow }
    else
      render "basic_setting/update",:locals=>{:resource=>@work_flow }
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
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@work_flow} }
    end
  end
end
