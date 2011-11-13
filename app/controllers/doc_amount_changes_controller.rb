class DocAmountChangesController < InheritedResources::Base
  def create
    create! do |wants|
      wants.js { render :index }
    end
  end

  def destroy
    destroy! do |wants|
      wants.js { render :index}
    end
  end
end
