#coding: utf-8
class FeeStandardsController < ApplicationController
  # GET /fee_standards
  # GET /fee_standards.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"FeeStandard",:lookup=>true,:addable=>true,:deletable=>true,:layout=>true
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
    end
  end

  # POST /fee_standards
  # POST /fee_standards.xml
  def create
    @fee_standard = FeeStandard.new(params[:fee_standard])
    if @fee_standard.save
      @message="创建成功"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@fee_standard)}
    end
  end

  # PUT /fee_standards/1
  # PUT /fee_standards/1.xml
  def update
    @fee_standard = FeeStandard.find(params[:id])
    if @fee_standard.update_attributes(params[:fee_standard])
      @message="更新成功"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@fee_standard)}
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
    end
  end
end
