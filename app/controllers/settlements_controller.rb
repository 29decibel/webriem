#coding: utf-8
class SettlementsController < ApplicationController
  # GET /settlements
  # GET /settlements.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"Settlement"
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
    end
  end

  # POST /settlements
  # POST /settlements.xml
  def create
    @settlement = Settlement.new(params[:settlement])
    if @settlement.save
      @message="创建成功"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@settlement)}
    end
  end

  # PUT /settlements/1
  # PUT /settlements/1.xml
  def update
    @settlement = Settlement.find(params[:id])
    if @settlement.update_attributes(params[:settlement])
      @message="更新成功"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@settlement)}
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
    end
  end
end
