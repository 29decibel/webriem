#coding: utf-8
class DepsController < ApplicationController
  # GET /deps
  def index
    @resources=Dep.page(params[:page]).per(20)
    @model_s_name="dep"
    @model_p_name="deps"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end
  
  # GET /currencies/new
  def new
    @dep = Dep.new
    render "basic_setting/new",:locals=>{:resource=>@dep}
  end

  def edit
    @dep = Dep.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@dep}}
    end
  end
  # GET /deps/1
  #显示所有的部门在这里啊
  def show
    @dep = Dep.find(params[:id])
    if @dep.parent_dep==nil
      @parent_dep="#{I18n.t('controller_msg.no_parent_dep')}"
    else
      @parent_dep=@dep.parent_dep.name
    end
  end

  # POST /deps
  def create
    @dep = Dep.new(params[:dep])
    if !@dep.save
      render "basic_setting/new",:locals=>{:resource=>@dep }
    else
      redirect_to index
    end
  end

  # PUT /deps/1
  def update
    @dep = Dep.find(params[:id])
    if !@dep.update_attributes(params[:dep])
      render "basic_setting/edit",:locals=>{:resource=>@dep}
    else
      render "basic_setting/update",:locals=>{:resource=>@dep}
    end
  end

  # DELETE /deps/1
  def destroy
    @dep = Dep.find(params[:id])
    @dep.destroy
    render "basic_setting/destroy",:locals=>{:resource=>@dep}
  end
end
