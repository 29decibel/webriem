class ModelSearchController < ApplicationController
  def index
    #get the class name
    @class=eval(params[:class_name])
    @results=@class.all
    render :layout=>false if params[:bare]=="true"
  end
  def with
    @class=eval(params[:class_name])
    column=params[:filter][:column_name]
    filter_text=params[:filter_text]
    if filter_text.blank?
      @results=@class.all
    else
      if @class.respond_to? :custom_query
        condition_hash=@class.custom_query(column,filter_text)
      end
      if condition_hash
        @results=@class.all(:include=>condition_hash[:include],:conditions=>[condition_hash[:conditions],"%#{filter_text}%"])
      else
        @results=@class.where("#{column} like ?",'%'+filter_text+'%')
      end
    end
    render "with"
  end

end
