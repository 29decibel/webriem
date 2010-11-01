#coding: utf-8
class ExtraWorkStandardsController < ApplicationController
  # GET /extra_work_standards
  # GET /extra_work_standards.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"ExtraWorkStandard",:lookup=>true,:addable=>true,:deletable=>true,:layout=>true
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
  end

  # GET /extra_work_standards/1/edit
  def edit
    @extra_work_standard = ExtraWorkStandard.find(params[:id])
  end

  # POST /extra_work_standards
  # POST /extra_work_standards.xml
  def create
    @extra_work_standard = ExtraWorkStandard.new(params[:extra_work_standard])

    if @extra_work_standard.save
      @message="创建成功"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@extra_work_standard)}
    end
  end

  # PUT /extra_work_standards/1
  # PUT /extra_work_standards/1.xml
  def update
    @extra_work_standard = ExtraWorkStandard.find(params[:id])

    if @extra_work_standard.update_attributes(params[:extra_work_standard])
      @message="更新成功"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@duty)}
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
    end
  end
end
