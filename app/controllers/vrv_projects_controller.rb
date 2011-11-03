class VrvProjectsController < InheritedResources::Base
  layout :vrv_project

  private
  def vrv_project
    action_name == 'index' ? "application" : 'vrv_project'
  end

end
