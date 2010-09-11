#coding: utf-8
class TransportationsController < ApplicationController
  # GET /transportations
  # GET /transportations.xml
  def index
    @transportations = Transportation.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @transportations }
    end
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

  # GET /transportations/1/edit
  def edit
    @transportation = Transportation.find(params[:id])
  end

  # POST /transportations
  # POST /transportations.xml
  def create
    @transportation = Transportation.new(params[:transportation])

    respond_to do |format|
      if @transportation.save
        format.html { redirect_to(@transportation, :notice => '交通方式添加成功') }
        format.xml  { render :xml => @transportation, :status => :created, :location => @transportation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transportation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transportations/1
  # PUT /transportations/1.xml
  def update
    @transportation = Transportation.find(params[:id])

    respond_to do |format|
      if @transportation.update_attributes(params[:transportation])
        format.html { redirect_to(@transportation, :notice => '交通方式修改成功') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transportation.errors, :status => :unprocessable_entity }
      end
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
