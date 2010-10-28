class ModelSearchController < ApplicationController
  def index
    #get the class name
    @class=eval(params[:class_name])
    @results=params[:pre_condition] ? @class.where(params[:pre_condition]): @class.scoped
    render :layout=>false if params[:bare]=="true"
  end
  def with
    @class=eval(params[:class_name])
    column=params[:filter][:column_name]
    filter_text=params[:filter_text]
    #filter by the pre sql para
    @result=@class.where(params[:pre_sql]) if params[:pre_sql]
    pre_condition=params[:pre_condition]
    @results=params[:pre_condition] ? @class.where(params[:pre_condition]) : @class.scoped
    if !filter_text.blank?
      if @class.respond_to? :custom_query
        condition_hash=@class.custom_query(column,filter_text)
        logger.info condition_hash
      end
      #get the result from the custom query
      if condition_hash
        @results=@results.all(:include=>condition_hash[:include],:conditions=>[condition_hash[:conditions],"%#{filter_text}%"])
        logger.info "now the result count is #{@results.count}"
      else
        if !@class.respond_to? :custom_select
          @results=@results.where("#{column} like ?",'%'+filter_text+'%')
        end
      end
      #add another logic that custom filter,this is in use when the query has completed
      if @class.respond_to? :custom_select
        @results=@class.custom_select(@results,filter_text)
        logger.info "custom selcted .. result count is #{@results.count}"
      end
    end
  end
end
