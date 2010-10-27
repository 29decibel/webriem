#coding: utf-8
class RolesController < ApplicationController
  # GET /roles
  # GET /roles.xml
  def index
    redirect_to :controller=>"model_search",:action=>"index",:class_name=>"Role",:lookup=>true,:addable=>true,:deletable=>true
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
    #set the person have such a role
    params[:people_ids].split('_').each do |person_id|
      person=Person.find(person_id.to_i)
      person.update_attribute(:role_id,@role.id)
    end
    #build the menu rights
    params[:menu_ids].split('_').each do |menu_id|
      @role.menu_rights.build(:menu_id=>menu_id)
    end
    if @role.save
      @message="创建成功"
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
     @role.people.clear
     #set the person have such a role
     params[:people_ids].split('_').each do |person_id|
       person=Person.find(person_id.to_i)
       person.update_attribute(:role_id,@role.id)
     end
     @role.menu_rights.clear
     #build the menu rights
     params[:menu_ids].split('_').each do |menu_id|
       @role.menu_rights.build(:menu_id=>menu_id)
     end
      if @role.update_attributes(params[:role])
        @message="更新成功"
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
