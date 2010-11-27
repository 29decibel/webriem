#coding: utf-8
class TransportationsController < ApplicationController
  # GET /transportations
  # GET /transportations.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"Transportation",:lookup=>true,:addable=>true,:deletable=>true,:layout=>true
  end

  # GET /transportations/1
  # GET /transportations/1.xml
  def show
    @transportation = Transportation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transportation }
    end
  end

  # GET /transportations/new
  # GET /transportations/new.xml
  def new
    @transportation = Transportation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transportation }
    end
  end

  # POST /transportations
  # POST /transportations.xml
  def create
    @transportation = Transportation.new(params[:transportation])
    if @transportation.save
      @message="#{I18n.t('controller_msg.create_ok')}"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@transportation)}
    end
  end

  # PUT /transportations/1
  # PUT /transportations/1.xml
  def update
    @transportation = Transportation.find(params[:id])
    if @transportation.update_attributes(params[:transportation])
      @message="#{I18n.t('controller_msg.update_ok')}"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@transportation)}
    end
  end

  # DELETE /transportations/1
  # DELETE /transportations/1.xml
  def destroy
    @transportation = Transportation.find(params[:id])
    @transportation.destroy

    respond_to do |format|
      format.html { redirect_to(transportations_url) }
      format.xml  { head :ok }
    end
  end
end
