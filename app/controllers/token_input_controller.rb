class TokenInputController < ApplicationController
  def search
    model=eval(params[:model])
    resource=nil
    if params[:q]=="?"
      resource=model.all
    else
      if model.respond_to? "token_filter"
        resource=model.token_filter(params[:q])
      else
        resource=model.where("name like ? ","%#{params[:q]=='no' ? '' : params[:q]}%")
      end
    end
    render :json=>resource.map(&:attributes)
  end
end
