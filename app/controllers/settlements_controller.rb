#coding: utf-8
class SettlementsController < ApplicationController
  # GET /settlements
  # GET /settlements.xml
  def index
    @resources=Settlement.all
    @model_s_name="settlement"
    @model_p_name="settlements"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  def edit
    @settlement = Settlement .find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@settlement }}
    end 
  end
  # GET /settlements/1
  # GET /settlements/1.xml
  def show
    @settlement = Settlement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @settlement }
    end
  end

  # GET /settlements/new
  # GET /settlements/new.xml
  def new
    @settlement = Settlement.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @settlement }
      format.js { render "basic_setting/new",:locals=>{:resource=>@settlement}}
    end
  end

  # POST /settlements
  # POST /settlements.xml
  def create
    @settlement = Settlement.new(params[:settlement])
    if !@settlement.save
      render "basic_setting/new",:locals=>{:resource=>@settlement }
    else
      redirect_to settlements_path
    end
  end

  # PUT /settlements/1
  # PUT /settlements/1.xml
  def update
    @settlement = Settlement.find(params[:id])
    if !@settlement.update_attributes(params[:settlement])
      render "basic_setting/edit",:locals=>{:resource=>@settlement}
    else
      render "basic_setting/update",:locals=>{:resource=>@settlement}
    end
  end

  # DELETE /settlements/1
  # DELETE /settlements/1.xml
  def destroy
    @settlement = Settlement.find(params[:id])
    @settlement.destroy

    respond_to do |format|
      format.html { redirect_to(settlements_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@settlement} }
    end
  end
end
