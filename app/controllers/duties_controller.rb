#coding: utf-8
class DutiesController < ApplicationController
  # GET /duties
  # GET /duties.xml
  def index
    @duties = Duty.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @duties }
    end
  end

  # GET /duties/1
  # GET /duties/1.xml
  def show
    @duty = Duty.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @duty }
    end
  end

  # GET /duties/new
  # GET /duties/new.xml
  def new
    @duty = Duty.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @duty }
    end
  end

  # GET /duties/1/edit
  def edit
    @duty = Duty.find(params[:id])
  end

  # POST /duties
  # POST /duties.xml
  def create
    @duty = Duty.new(params[:duty])

    respond_to do |format|
      if @duty.save
        format.html { redirect_to(@duty, :notice => '职务添加成功') }
        format.xml  { render :xml => @duty, :status => :created, :location => @duty }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @duty.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /duties/1
  # PUT /duties/1.xml
  def update
    @duty = Duty.find(params[:id])

    respond_to do |format|
      if @duty.update_attributes(params[:duty])
        format.html { redirect_to(@duty, :notice => '职务修改成功') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @duty.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /duties/1
  # DELETE /duties/1.xml
  def destroy
    @duty = Duty.find(params[:id])
    @duty.destroy

    respond_to do |format|
      format.html { redirect_to(duties_url) }
      format.xml  { head :ok }
    end
  end
end
