#coding: utf-8
class TransportationsController < ApplicationController
  # GET /transportations
  # GET /transportations.xml
  def index
    @resources=Transportation.all
    @model_s_name="transportation"
    @model_p_name="transportations"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  def edit
    @transportation = Transportation.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@transportation}}
    end  
  end
  # GET /transportations/1
  # GET /transportations/1.xml
  def show
    @transportation = Transportation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transportation }
    end
  end

  # GET /transportations/new
  # GET /transportations/new.xml
  def new
    @transportation = Transportation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transportation }
      format.js { render "basic_setting/new",:locals=>{:resource=>@transportation}}
    end
  end

  # POST /transportations
  # POST /transportations.xml
  def create
    @transportation = Transportation.new(params[:transportation])
    if !@transportation .save
      render "basic_setting/new",:locals=>{:resource=>@transportation  }
    else
      redirect_to transportations_path  
    end
  end

  # PUT /transportations/1
  # PUT /transportations/1.xml
  def update
    @transportation = Transportation.find(params[:id])
    if !@transportation .update_attributes(params[:transportation])
      render "basic_setting/edit",:locals=>{:resource=>@transportation  }
    else
      render "basic_setting/update",:locals=>{:resource=>@transportation  }
    end
  end

  # DELETE /transportations/1
  # DELETE /transportations/1.xml
  def destroy
    @transportation = Transportation.find(params[:id])
    @transportation.destroy

    respond_to do |format|
      format.html { redirect_to(transportations_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@transportation} }
    end
  end
end
