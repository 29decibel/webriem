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
    #filter by the pre sql para
    @result=@class.where(params[:pre_sql]) if params[:pre_sql]
    if !filter_text.blank?
      if @class.respond_to? :custom_query
        condition_hash=@class.custom_query(column,filter_text)
      end
      #get the result from the custom query
      if condition_hash
        @results=@class.all(:include=>condition_hash[:include],:conditions=>[condition_hash[:conditions],"%#{filter_text}%"])
      else
        if @class.respond_to? :custom_select
          @results=@class.all
        else
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
