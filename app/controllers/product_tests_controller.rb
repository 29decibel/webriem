class ProductTestsController < InheritedResources::Base
  layout 'vrv_project'
  belongs_to :vrv_project
end
