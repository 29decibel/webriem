class NetworkConditionsController < InheritedResources::Base
  layout 'vrv_project'
  belongs_to :vrv_project,:singleton => true
  def update
    params[:network_condition][:product_ids] ||= []
    update!
  end
end
