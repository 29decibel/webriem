class TokenInputController < ApplicationController
  def search
    model=eval(params[:model])
    resource=nil
    if params[:q]=="?"
      resource=model.all
    else
      col = params[:search_col] || 'name'
      custom_q = params[:custom_q] || ' 1=1 '
      resource=model.where("#{col} like ? and #{custom_q.gsub(':','=')}","%#{params[:q]=='no' ? '' : params[:q]}%")
    end
    render :json=>resource.map(&:attributes)
  end
end
