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

  def edit
    @lodging = Lodging.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@lodging}}
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
      format.js { render "basic_setting/new",:locals=>{:resource=>@lodging}}
    end
  end

  # POST /lodgings
  # POST /lodgings.xml
  def create
    @lodging = Lodging.new(params[:lodging])
    if !@lodging.save
      render "basic_setting/new",:locals=>{:resource=>@lodging }
    else
      redirect_to index
    end
  end

  # PUT /lodgings/1
  # PUT /lodgings/1.xml
  def update
    @lodging = Lodging.find(params[:id])
    if !@lodging.update_attributes(params[:lodging])
      render "basic_setting/edit",:locals=>{:resource=>@lodging }
    else
      render "basic_setting/update",:locals=>{:resource=>@lodging}
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
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@account} }
    end
  end
end
