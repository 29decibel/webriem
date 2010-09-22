class WorkFlowsController < ApplicationController
  # GET /work_flows
  # GET /work_flows.xml
  def index
    @work_flows = WorkFlow.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @work_flows }
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @work_flow }
    end
  end

  # GET /work_flows/1/edit
  def edit
    @work_flow = WorkFlow.find(params[:id])
  end

  # POST /work_flows
  # POST /work_flows.xml
  def create
    @work_flow = WorkFlow.new(params[:work_flow])

    respond_to do |format|
      if @work_flow.save
        format.html { redirect_to(@work_flow, :notice => 'Work flow was successfully created.') }
        format.xml  { render :xml => @work_flow, :status => :created, :location => @work_flow }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @work_flow.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /work_flows/1
  # PUT /work_flows/1.xml
  def update
    @work_flow = WorkFlow.find(params[:id])

    respond_to do |format|
      if @work_flow.update_attributes(params[:work_flow])
        format.html { redirect_to(@work_flow, :notice => 'Work flow was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @work_flow.errors, :status => :unprocessable_entity }
      end
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
