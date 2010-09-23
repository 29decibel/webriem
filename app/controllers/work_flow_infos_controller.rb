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

  # GET /work_flow_infos/1/edit
  def edit
    @work_flow_info = WorkFlowInfo.find(params[:id])
  end

  # POST /work_flow_infos
  # POST /work_flow_infos.xml
  def create
    @work_flow_info = WorkFlowInfo.new(params[:work_flow_info])

    respond_to do |format|
      if @work_flow_info.save
        format.html { redirect_to(@work_flow_info, :notice => 'Work flow info was successfully created.') }
        format.xml  { render :xml => @work_flow_info, :status => :created, :location => @work_flow_info }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @work_flow_info.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /work_flow_infos/1
  # PUT /work_flow_infos/1.xml
  def update
    @work_flow_info = WorkFlowInfo.find(params[:id])

    respond_to do |format|
      if @work_flow_info.update_attributes(params[:work_flow_info])
        format.html { redirect_to(@work_flow_info, :notice => 'Work flow info was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @work_flow_info.errors, :status => :unprocessable_entity }
      end
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
