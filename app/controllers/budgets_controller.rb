#coding: utf-8
class BudgetsController < ApplicationController
  # GET /budgets
  # GET /budgets.xml
  def index
    @budgets = Budget.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @budgets }
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
    end
  end

  # GET /budgets/1/edit
  def edit
    @budget = Budget.find(params[:id])
  end

  # POST /budgets
  # POST /budgets.xml
  def create
    @budget = Budget.new(params[:budget])

    respond_to do |format|
      if @budget.save
        format.html { redirect_to(@budget, :notice => '预算数据添加成功') }
        format.xml  { render :xml => @budget, :status => :created, :location => @budget }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @budget.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /budgets/1
  # PUT /budgets/1.xml
  def update
    @budget = Budget.find(params[:id])

    respond_to do |format|
      if @budget.update_attributes(params[:budget])
        format.html { redirect_to(@budget, :notice => '预算数据更新成功') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @budget.errors, :status => :unprocessable_entity }
      end
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
    end
  end
end
