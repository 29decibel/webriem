#coding: utf-8
class ExtraWorkStandardsController < ApplicationController
  # GET /extra_work_standards
  # GET /extra_work_standards.xml
  def index
    @resources=ExtraWorkStandard.all
    @model_s_name="extra_work_standard"
    @model_p_name="extra_work_standards"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  # GET /extra_work_standards/1
  # GET /extra_work_standards/1.xml
  def show
    @extra_work_standard = ExtraWorkStandard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @extra_work_standard }
    end
  end

  # GET /extra_work_standards/new
  # GET /extra_work_standards/new.xml
  def new
    @extra_work_standard = ExtraWorkStandard.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @extra_work_standard }
      format.js { render "basic_setting/new",:locals=>{:resource=>@extra_work_standard }}
    end
  end

  # GET /extra_work_standards/1/edit
  def edit
    @extra_work_standard = ExtraWorkStandard.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@extra_work_standard }}
    end
  end

  # POST /extra_work_standards
  # POST /extra_work_standards.xml
  def create
    @extra_work_standard = ExtraWorkStandard.new(params[:extra_work_standard])

    if !@extra_work_standard .save
      render "basic_setting/new",:locals=>{:resource=>@extra_work_standard   }
    else
      redirect_to extra_work_standards_path
    end
  end

  # PUT /extra_work_standards/1
  # PUT /extra_work_standards/1.xml
  def update
    @extra_work_standard = ExtraWorkStandard.find(params[:id])

    if !@extra_work_standard.update_attributes(params[:extra_work_standard])
      render "basic_setting/edit",:locals=>{:resource=>@extra_work_standard }
    else
      render "basic_setting/update",:locals=>{:resource=>@extra_work_standard}
    end
  end

  # DELETE /extra_work_standards/1
  # DELETE /extra_work_standards/1.xml
  def destroy
    @extra_work_standard = ExtraWorkStandard.find(params[:id])
    @extra_work_standard.destroy

    respond_to do |format|
      format.html { redirect_to(extra_work_standards_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@extra_work_standard } }
    end
  end
end
