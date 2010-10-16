#coding: utf-8
class LodgingsController < ApplicationController
  # GET /lodgings
  # GET /lodgings.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"Lodging"
  end

  # GET /lodgings/1
  # GET /lodgings/1.xml
  def show
    @lodging = Lodging.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lodging }
    end
  end

  # GET /lodgings/new
  # GET /lodgings/new.xml
  def new
    @lodging = Lodging.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lodging }
    end
  end

  # POST /lodgings
  # POST /lodgings.xml
  def create
    @lodging = Lodging.new(params[:lodging])
    if @lodging.save
      @message="创建成功"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@lodging)}
    end
  end

  # PUT /lodgings/1
  # PUT /lodgings/1.xml
  def update
    @lodging = Lodging.find(params[:id])
    if @lodging.update_attributes(params[:lodging])
      @message="更新成功"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@lodging)}
    end
  end

  # DELETE /lodgings/1
  # DELETE /lodgings/1.xml
  def destroy
    @lodging = Lodging.find(params[:id])
    @lodging.destroy

    respond_to do |format|
      format.html { redirect_to(lodgings_url) }
      format.xml  { head :ok }
    end
  end
end
