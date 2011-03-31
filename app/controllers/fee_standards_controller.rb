#coding: utf-8
class FeeStandardsController < ApplicationController
  # GET /fee_standards
  # GET /fee_standards.xml
  def index
    @resources=FeeStandard.all
    @model_s_name="fee_standard"
    @model_p_name="fee_standards"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  def edit
    @fee_standard = FeeStandard.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@fee_standard}}
    end
  end
  # GET /fee_standards/1
  # GET /fee_standards/1.xml
  def show
    @fee_standard = FeeStandard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @fee_standard }
    end
  end

  # GET /fee_standards/new
  # GET /fee_standards/new.xml
  def new
    @fee_standard = FeeStandard.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fee_standard }
      format.js { render "basic_setting/new",:locals=>{:resource=>@fee_standard  }}
    end
  end

  # POST /fee_standards
  # POST /fee_standards.xml
  def create
    @fee_standard = FeeStandard.new(params[:fee_standard])
    if !@fee_standard .save
      render "basic_setting/new",:locals=>{:resource=>@fee_standard  }
    else
      redirect_to fee_standards_path
    end
  end

  # PUT /fee_standards/1
  # PUT /fee_standards/1.xml
  def update
    @fee_standard = FeeStandard.find(params[:id])
    if !@fee_standard .update_attributes(params[:fee_standard ])
      render "basic_setting/edit",:locals=>{:resource=>@fee_standard  }
    else
      render "basic_setting/update",:locals=>{:resource=>@fee_standard}
    end
  end

  # DELETE /fee_standards/1
  # DELETE /fee_standards/1.xml
  def destroy
    @fee_standard = FeeStandard.find(params[:id])
    @fee_standard.destroy

    respond_to do |format|
      format.html { redirect_to(fee_standards_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@fee_standard} }
    end
  end
end
