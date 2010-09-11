#coding: utf-8
class SettlementsController < ApplicationController
  # GET /settlements
  # GET /settlements.xml
  def index
    @settlements = Settlement.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @settlements }
    end
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

  # GET /settlements/1/edit
  def edit
    @settlement = Settlement.find(params[:id])
  end

  # POST /settlements
  # POST /settlements.xml
  def create
    @settlement = Settlement.new(params[:settlement])

    respond_to do |format|
      if @settlement.save
        format.html { redirect_to(@settlement, :notice => '结算方式添加成功') }
        format.xml  { render :xml => @settlement, :status => :created, :location => @settlement }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @settlement.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /settlements/1
  # PUT /settlements/1.xml
  def update
    @settlement = Settlement.find(params[:id])

    respond_to do |format|
      if @settlement.update_attributes(params[:settlement])
        format.html { redirect_to(@settlement, :notice => '结算方式修改成功') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @settlement.errors, :status => :unprocessable_entity }
      end
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
