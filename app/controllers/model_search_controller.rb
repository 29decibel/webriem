class ModelSearchController < ApplicationController
  def index
    #get the class name
    @class=eval(params[:class_name])
    @results=params[:pre_condition]?@class.where(params[:pre_condition]): @class.scoped
    render :layout=>false if params[:bare]=="true"
  end
  def with
    @class=eval(params[:class_name])
    column=params[:filter][:column_name]
    filter_text=params[:filter_text]
    pre_condition=params[:pre_condition]
    @results=params[:pre_condition]?@class.where(params[:pre_condition]): @class.scoped
    if !filter_text.blank?
      if @class.respond_to? :custom_query
        condition_hash=@class.custom_query(column,filter_text)
      end
      #get the result from the custom query
      if condition_hash
        @results=@results.all(:include=>condition_hash[:include],:conditions=>[condition_hash[:conditions],"%#{filter_text}%"])
      else
        if !@class.respond_to? :custom_select
          @results=@class.where("#{column} like ?",'%'+filter_text+'%')
        end
      end
      #add another logic that custom filter,this is in use when the query has completed
      if @class.respond_to? :custom_select
        @results=@class.custom_select(@results,filter_text)
      end
    end
  end

end
