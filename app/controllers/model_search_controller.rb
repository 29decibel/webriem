class ModelSearchController < ApplicationController
  def index
    #get the class name
    @class=eval(params[:class_name])
    if params[:pre_condition]
      if params[:joins]
        @results=@class.joins(params[:joins].to_sym).where(params[:pre_condition])
      else
         @results=@class.where(params[:pre_condition])
      end      
    else
      @results=@class.scoped
    end
    #final filter
    if params[:filter_method] and @class.respond_to?(params[:filter_method])
    	@results=@class.send(params[:filter_method],@results,current_user.person)
    end
    #render :text=>@results.first.id
    render :layout=>false if !params[:layout]
  end
  def with
    @class=eval(params[:class_name])
    column=params[:filter][:column_name]
    filter_text=params[:filter_text]
    #filter by the pre sql para
    @result=@class.where(params[:pre_sql]) if params[:pre_sql]
    if params[:pre_condition]
      if params[:joins]
        @results=@class.joins(params[:joins].to_sym).where(params[:pre_condition])
      else
         @results=@class.where(params[:pre_condition])
      end      
    else
      @results=@class.scoped
    end
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
        #if !@class.respond_to? :custom_select
          @results=@results.where("#{column} like ?",'%'+filter_text+'%')
        #end
      end
      #add another logic that custom filter,this is in use when the query has completed
      if @class.respond_to? :custom_select
        @results=@class.custom_select(@results,column,filter_text)
        puts @result
        logger.info "#{@class} custom selcted .. result count is #{@results.count}"
      end
    end
    #final filter
    if params[:filter_method] and @class.respond_to?(params[:filter_method])
    	@results=@class.send(params[:filter_method],@results,current_user.person)
    end
  end
end
