class ContractPredictsController < InheritedResources::Base
  layout 'vrv_project'
  belongs_to :vrv_project,:singleton => true
end
