class VrvProjectsController < InheritedResources::Base
  before_filter :authenticate_user!
  layout :vrv_project

  def index
    @search = VrvProject.search(params[:search])
    @vrv_projects = params[:search] ?  @search.all : []
    respond_to do |wants|
      wants.js
      wants.html
    end
  end

  def preview
    @vrv_project = VrvProject.find(params[:id])
  end

  def create
    create!
    @vrv_project.person = current_user.person
    @vrv_project.save
  end

  def submit
    @vrv_project = VrvProject.find(params[:id])
    @vrv_project.submit
    redirect_to @vrv_project
  end

  def approve
    @vrv_project = VrvProject.find(params[:id])
    @vrv_project.approve
    redirect_to @vrv_project
  end

  def reject
    @vrv_project = VrvProject.find(params[:id])
    @vrv_project.reject
    redirect_to @vrv_project   
  end

  def recall
    @vrv_project = VrvProject.find(params[:id])
    @vrv_project .recall
    redirect_to @vrv_project   
  end

  def generate_contract_doc
    @vrv_project = VrvProject.find(params[:id])
    doc = @vrv_project.generate_contract_doc
    redirect_to edit_doc_head_path(doc)
  end

  private
  def vrv_project
    action_name == 'index' ? "application" : 'vrv_project'
  end

end
