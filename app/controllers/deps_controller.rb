#coding: utf-8
class DepsController < ApplicationController
  # GET /deps
  # GET /deps.xml
  def index
    @deps = Dep.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @deps }
    end
  end

  # GET /deps/1
  # GET /deps/1.xml
  #显示所有的部门在这里啊
  def show
    @dep = Dep.find(params[:id])
    if @dep.parent_dep==nil
      @parent_dep="没有上级部门"
    else
      @parent_dep=@dep.parent_dep.name
    end
    #@parent_dep=@dep.parent_dep=nil ? "sss" : @dep.parent_dep.name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @dep }
    end
  end

  # GET /deps/new
  # GET /deps/new.xml
  def new
    @dep = Dep.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @dep }
      format.js
    end
  end

  # GET /deps/1/edit
  def edit
    @dep = Dep.find(params[:id])
  end

  # POST /deps
  # POST /deps.xml
  def create
    @dep = Dep.new(params[:dep])

    respond_to do |format|
      if @dep.save
        format.js
        format.html { redirect_to(@dep, :notice => '部门添加成功') }
        format.xml  { render :xml => @dep, :status => :created, :location => @dep }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @dep.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /deps/1
  # PUT /deps/1.xml
  def update
    @dep = Dep.find(params[:id])

    respond_to do |format|
      if @dep.update_attributes(params[:dep])
        format.html { redirect_to(@dep, :notice => '部门修改成功') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @dep.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /deps/1
  # DELETE /deps/1.xml
  def destroy
    @dep = Dep.find(params[:id])
    @dep.destroy

    respond_to do |format|
      format.html { redirect_to(deps_url) }
      format.xml  { head :ok }
    end
  end
end
