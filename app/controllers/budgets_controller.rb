#coding: utf-8
class BudgetsController < ApplicationController
  # GET /budgets
  # GET /budgets.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"Budget"
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


  # POST /budgets
  # POST /budgets.xml
  def create
    @budget = Budget.new(params[:budget])
    if @budget.save
      @message="创建成功"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@budget)}
    end
  end

  # PUT /budgets/1
  # PUT /budgets/1.xml
  def update
    @budget = Budget.find(params[:id])
    if @budget.update_attributes(params[:budget])
      @message="更新成功"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@budget)}
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
