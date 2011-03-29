#coding: utf-8
class RolesController < ApplicationController
  # GET /roles
  # GET /roles.xml
  def index
    @resources=Role.all
    @model_s_name="role"
    @model_p_name="roles"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @role }
    end
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    @role = Role.new
    render "basic_setting/new",:locals=>{:resource=>@role}
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
    render "basic_setting/edit",:locals=>{:resource=>@role}
  end

  # POST /roles
  # POST /roles.xml
  def create
    @role = Role.new(params[:role])
    #update the people info
    if params[:menus]
      @role.menu_ids=params[:menus].join(",")
    end
    if !@role.save
      render "basic_setting/new",:locals=>{:resource=>@role }
    else
      @roles=Role.all
      render "basic_setting/create",:locals=>{:resource=>@role,:resources=>@roles}
    end
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
     @role = Role.find(params[:id])
     #update the people info
     if params[:menus]
       @role.update_attributes(:menu_ids=>params[:menus].join(","))
     end
    if !@role.update_attributes(params[:role])
      render "basic_setting/edit",:locals=>{:resource=>@role}
    else
      render "basic_setting/update",:locals=>{:resource=>@role}
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role = Role.find(params[:id])
    @delete_id=@role.id
    @role.destroy
    render "basic_setting/destroy",:locals=>{:resource=>@role}
  end
end
