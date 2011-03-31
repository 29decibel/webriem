#coding: utf-8
class FeesController < ApplicationController
  # GET /fees
  # GET /fees.xml
  def index
    @resources=Fee.all
    @model_s_name="fee"
    @model_p_name="fees"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  # GET /fees/1
  # GET /fees/1.xml
  def show
    @fee = Fee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fee }
    end
  end

  def edit
    @fee = Fee.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@fee}}
    end
  end
  # GET /fees/new
  # GET /fees/new.xml
  def new
    @fee = Fee.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fee }
      format.js { render "basic_setting/new",:locals=>{:resource=>@fee }}
    end
  end

  # POST /fees
  # POST /fees.xml
  def create
    @fee = Fee.new(params[:fee])
    if !@fee.save
      render "basic_setting/new",:locals=>{:resource=>@fee }
      return
    else
      redirect_to fees_path
    end
  end

  # PUT /fees/1
  # PUT /fees/1.xml
  def update
    @fee = Fee.find(params[:id])
    if !@fee.update_attributes(params[:fee])
      render "basic_setting/edit",:locals=>{:resource=>@fee }
    else
      render "basic_setting/update",:locals=>{:resource=>@fee}
    end
  end

  # DELETE /fees/1
  # DELETE /fees/1.xml
  def destroy
    @fee = Fee.find(params[:id])
    @fee.destroy

    respond_to do |format|
      format.html { redirect_to(fees_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@fee} }
    end
  end
end
