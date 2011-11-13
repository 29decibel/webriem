class ApproverInfosController < InheritedResources::Base
  def update
    update! do |wants|
      wants.js { render :update }
    end
  end  
end
