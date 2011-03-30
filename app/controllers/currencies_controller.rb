#coding: utf-8
class CurrenciesController < ApplicationController
  # GET /currencies
  # GET /currencies.xml
  def index
    @resources=Currency.all
    @model_s_name="currency"
    @model_p_name="currencies"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
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
      format.js { render "basic_setting/new",:locals=>{:resource=>@currency }}
    end
  end

  # POST /currencies
  # POST /currencies.xml
  def create
    @currency = Currency.new(params[:currency])
    if !@currency.save
      render "basic_setting/new",:locals=>{:resource=>@currency }
    else
      redirect_to index
    end
  end

  # PUT /currencies/1
  # PUT /currencies/1.xml
  def update
    @currency = Currency.find(params[:id])
    if !@currency.update_attributes(params[:currency])
      render "basic_setting/edit",:locals=>{:resource=>@currency }
    else
      render "basic_setting/update",:locals=>{:resource=>@currency}
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
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@currency} }
    end
  end
end
