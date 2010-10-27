#coding: utf-8
class FeesController < ApplicationController
  # GET /fees
  # GET /fees.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"Fee",:lookup=>true,:addable=>true,:deletable=>true
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

  # GET /fees/new
  # GET /fees/new.xml
  def new
    @fee = Fee.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @fee }
    end
  end

  # POST /fees
  # POST /fees.xml
  def create
    @fee = Fee.new(params[:fee])
    if @fee.save
      @message="创建成功"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@fee)}
    end
  end

  # PUT /fees/1
  # PUT /fees/1.xml
  def update
    @fee = Fee.find(params[:id])
    if @fee.update_attributes(params[:fee])
      @message="更新成功"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@fee)}
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
    end
  end
end
