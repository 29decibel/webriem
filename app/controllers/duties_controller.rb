#coding: utf-8
class DutiesController < ApplicationController
  # GET /duties
  # GET /duties.xml
  def index
    @resources=Duty.page(params[:page]).per(20)
    @model_s_name="duty"
    @model_p_name="duties"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
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
    render "basic_setting/new",:locals=>{:resource=>@duty}
  end

  def edit
    @duty = Duty.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@duty}}
    end
  end
  # POST /duties
  # POST /duties.xml
  def create
    @duty = Duty.new(params[:duty])
    if !@duty.save
      render "basic_setting/new",:locals=>{:resource=>@duty }
    else
      redirect_to duties_path
    end
  end

  # PUT /duties/1
  # PUT /duties/1.xml
  def update
    @duty = Duty.find(params[:id])
    if !@duty.update_attributes(params[:duty])
      render "basic_setting/edit",:locals=>{:resource=>@duty}
    else
      render "basic_setting/update",:locals=>{:resource=>@duty}
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
      format.js {render "basic_setting/destroy",:locals=>{:resource=>@duty}}
    end
  end
end
