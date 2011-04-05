class TokenInputController < ApplicationController
  def search
    model=eval(params[:model])
    resource=nil
    if params[:q]=="?"
      resource=model.all
    else
      resource=model.where("name like ?","%#{params[:q]}%")
    end
    render :json=>resource.map(&:attributes)
  end

end
