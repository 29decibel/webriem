#coding: utf-8
class LodgingsController < ApplicationController
  # GET /lodgings
  # GET /lodgings.xml
  def index
    @resources=Lodging.all
    @model_s_name="lodging"
    @model_p_name="lodgings"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
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
      @message="#{I18n.t('controller_msg.create_ok')}"
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
      @message="#{I18n.t('controller_msg.update_ok')}"
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
