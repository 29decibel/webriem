#coding: utf-8
class CurrenciesController < ApplicationController
  # GET /currencies
  # GET /currencies.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"Currency",:lookup=>true,:addable=>true,:deletable=>true,:layout=>true
  end

  # GET /currencies/1
  # GET /currencies/1.xml
  def show
    @currency = Currency.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @currency }
    end
  end

  # GET /currencies/new
  # GET /currencies/new.xml
  def new
    @currency = Currency.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @currency }
    end
  end

  # POST /currencies
  # POST /currencies.xml
  def create
    @currency = Currency.new(params[:currency])
    if @currency.save
      @message="创建成功"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@currency)}
    end
  end

  # PUT /currencies/1
  # PUT /currencies/1.xml
  def update
    @currency = Currency.find(params[:id])
    if @currency.update_attributes(params[:currency])
      @message="更新成功"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@currency)}
    end
  end

  # DELETE /currencies/1
  # DELETE /currencies/1.xml
  def destroy
    @currency = Currency.find(params[:id])
    @currency.destroy

    respond_to do |format|
      format.html { redirect_to(currencies_url) }
      format.xml  { head :ok }
    end
  end
end
