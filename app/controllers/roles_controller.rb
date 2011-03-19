#coding: utf-8
class RolesController < ApplicationController
  # GET /roles
  # GET /roles.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"Role",:lookup=>true,:addable=>true,:deletable=>true,:layout=>true
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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @role }
    end
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
    if @role.save
      @message="#{I18n.t('controller_msg.create_ok')}"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@role)}
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
    if @role.update_attributes(params[:role])
      @message="#{I18n.t('controller_msg.update_ok')}"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@role)}
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    respond_to do |format|
      format.html { redirect_to(roles_url) }
      format.xml  { head :ok }
    end
  end
end
