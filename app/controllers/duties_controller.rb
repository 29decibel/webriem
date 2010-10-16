#coding: utf-8
class DutiesController < ApplicationController
  # GET /duties
  # GET /duties.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"Duty"
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
  end

  # POST /duties
  # POST /duties.xml
  def create
    @duty = Duty.new(params[:duty])
    if @duty.save
      @message="创建成功"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@duty)}
    end
  end

  # PUT /duties/1
  # PUT /duties/1.xml
  def update
    @duty = Duty.find(params[:id])
    if @duty.update_attributes(params[:duty])
      @message="更新成功"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@duty)}
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
