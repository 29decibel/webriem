#coding: utf-8
class RolesController < ApplicationController
  # GET /roles
  # GET /roles.xml
  def index
    @roles=Role.all
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
  end

  # GET /roles/1/edit
  def edit
    @role = Role.find(params[:id])
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
      render "new"
    end
    @roles=Role.all
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
      render "edit"
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role = Role.find(params[:id])
    @delete_id=@role.id
    @role.destroy
  end
end
