#coding: utf-8
class RegionsController < ApplicationController
  # GET /regions
  # GET /regions.xml
  def index
    @resources=Region.page(params[:page]).per(20)
    @model_s_name="region"
    @model_p_name="regions"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  # GET /regions/1
  # GET /regions/1.xml
  def show
    @region = Region.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @region }
    end
  end

  def edit
    @region = Region.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@region}}
    end
   
  end
  # GET /regions/new
  # GET /regions/new.xml
  def new
    @region = Region.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @region }
      format.js { render "basic_setting/new",:locals=>{:resource=>@region}}
    end
  end

  # POST /regions
  # POST /regions.xml
  def create
    @region = Region.new(params[:region])
    if !@region.save
      render "basic_setting/new",:locals=>{:resource=>@region}
    else
      redirect_to regions_path
    end
  end

  # PUT /regions/1
  # PUT /regions/1.xml
  def update
    @region = Region.find(params[:id])
    if !@region.update_attributes(params[:region])
      render "basic_setting/edit",:locals=>{:resource=>@region }
    else
      render "basic_setting/update",:locals=>{:resource=>@region}
    end
  end

  # DELETE /regions/1
  # DELETE /regions/1.xml
  def destroy
    @region = Region.find(params[:id])
    @region.destroy

    respond_to do |format|
      format.html { redirect_to(regions_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@region} }
    end
  end
end
