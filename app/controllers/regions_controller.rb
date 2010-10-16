#coding: utf-8
class RegionsController < ApplicationController
  # GET /regions
  # GET /regions.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"Region"
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

  # GET /regions/new
  # GET /regions/new.xml
  def new
    @region = Region.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @region }
    end
  end

  # POST /regions
  # POST /regions.xml
  def create
    @region = Region.new(params[:region])
    if @region.save
      @message="创建成功"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@region)}
    end
  end

  # PUT /regions/1
  # PUT /regions/1.xml
  def update
    @region = Region.find(params[:id])
    if @region.update_attributes(params[:region])
      @message="更新成功"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@region)}
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
    end
  end
end
