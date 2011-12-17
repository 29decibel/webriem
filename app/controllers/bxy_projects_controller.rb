class BxyProjectsController < InheritedResources::Base
  def create
    create!
    @bxy_project.person = current_user.person
    @bxy_project.save
  end
end
