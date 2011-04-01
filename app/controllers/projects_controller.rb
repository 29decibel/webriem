#coding: utf-8
class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml
  def index
    @resources=Project.page(params[:page]).per(20)
    @model_s_name="project"
    @model_p_name="projects"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
      format.js { render "basic_setting/new",:locals=>{:resource=>@project} }
    end
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    if !@project.save
      render "basic_setting/new",:locals=>{:resource=>@project }
    else
      @projects=Project.all
      render "basic_setting/create",:locals=>{:resource=>@project,:resources=>@projects}
    end
  end
  def edit
    @project = Project.find(params[:id])
    render "basic_setting/edit",:locals=>{:resource=>@project}
  end
  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])
    if !@project.update_attributes(params[:project])
      render "basic_setting/edit",:locals=>{:resource=>@project}
    else
      render "basic_setting/update",:locals=>{:resource=>@project}
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@project} }
    end
  end
end
