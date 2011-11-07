class VrvProjectsController < InheritedResources::Base
  layout :vrv_project

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

  private
  def vrv_project
    action_name == 'index' ? "application" : 'vrv_project'
  end

end
