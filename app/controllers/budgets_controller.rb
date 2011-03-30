#coding: utf-8
class BudgetsController < ApplicationController
  # GET /budgets
  # GET /budgets.xml
  def index
    @resources=Budget.all
    @model_s_name="budget"
    @model_p_name="budgets"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  def edit
    @budget = Budget.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@budget}}
    end
  end
  # GET /budgets/1
  # GET /budgets/1.xml
  def show
    @budget = Budget.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @budget }
    end
  end

  # GET /budgets/new
  # GET /budgets/new.xml
  def new
    @budget = Budget.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @budget }
      format.js { render "basic_setting/new",:locals=>{:resource=>@budget }}
    end
  end


  # POST /budgets
  # POST /budgets.xml
  def create
    @budget = Budget.new(params[:budget])
    if !@budget.save
      render "basic_setting/new",:locals=>{:resource=>@account }
    else
      redirect_to index
    end
  end

  # PUT /budgets/1
  # PUT /budgets/1.xml
  def update
    @budget = Budget.find(params[:id])
    if !@budget.update_attributes(params[:budget])
      render "basic_setting/edit",:locals=>{:resource=>@budget }
    else
      render "basic_setting/update",:locals=>{:resource=>@budget}
    end
  end

  # DELETE /budgets/1
  # DELETE /budgets/1.xml
  def destroy
    @budget = Budget.find(params[:id])
    @budget.destroy

    respond_to do |format|
      format.html { redirect_to(budgets_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@budget} }
    end
  end
end
