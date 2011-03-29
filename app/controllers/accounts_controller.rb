#coding: utf-8
class AccountsController < ApplicationController
  # GET /accounts
  # GET /accounts.xml
  def index
    @resources=Account.all
    @model_s_name="account"
    @model_p_name="accounts"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  # GET /accounts/1
  # GET /accounts/1.xml
  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account }
    end
  end
  def edit
    @account = Account.find(params[:id])
    render "basic_setting/edit",:locals=>{:resource=>@account}
  end

  # GET /accounts/new
  # GET /accounts/new.xml
  def new
    @account = Account.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account }
      format.js { render "basic_setting/new",:locals=>{:resource=>@account }}
    end
  end

  # POST /accounts
  # POST /accounts.xml
  def create
    @account = Account.new(params[:account])
    if !@account.save
      render "basic_setting/new",:locals=>{:resource=>@account }
    else
      @accounts=Account.all
      render "basic_setting/create",:locals=>{:resource=>@account,:resources=>@accounts}
    end
  end

  # PUT /accounts/1
  # PUT /accounts/1.xml
  def update
    @account = Account.find(params[:id])
    if !@account.update_attributes(params[:account])
      render "basic_setting/edit",:locals=>{:resource=>@account }
    else
      render "basic_setting/update",:locals=>{:resource=>@account}
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.xml
  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    respond_to do |format|
      format.html { redirect_to(accounts_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@account} }
    end
  end
end
