class GridDataController < ApplicationController
  protect_from_forgery
  respond_to :json
  #here is the main logic of getting data and filter data
  #    jqgrid :my_doc,:model=>"DocHead",:columns=>[{:name=>doc_no,:label=>'fff'}]
  #    jqgrid :dep,:model=>"Dep",:exclude_columns=["created_on,created_by"]
  #    jqgrid :budget_info,:data_getter=>"GridDataService.getBudgetInfo",:columns=>[{:name=>dep,:label=>"Dep"}]
  def from_model
    #get options from session
    opt=session[params[:widget_id]]
    puts params[:widget_id]
    puts "@@@@@@@@@@@@"
puts opt
    puts "@@@@@@@@@@@@"
    model = eval(opt[:model])
    fields = opt[:colModel].collect {|col| col[:name]}    
    find = {}
    find[:order] = params["sidx"] + " " + params["sord"] unless params["sidx"].empty?
    conditions = filter_bar_conditions(fields,params)
    find[:conditions] = conditions unless conditions.empty?
    #pager
    find[:per_page] = params["rows"] || 20
    find[:page] = params["page"] || 1
    #make the model scoped relation
    relation = model.scoped
    #joins
    opt[:joins].each {|join_relation| relation=relation.joins(join_relation)}
    #select
    relation = relation.select(opt[:select].join(','))
    #where
    relation = relation.where(opt[:where]) if opt[:where]
    #get the rows
    rows = relation.paginate(:all,find)
    row_count = relation.count(:all,:conditions => find[:conditions])
    
    respond_with rows.to_jqgrid_json(
      opt[:columns],#fields
      row_count,#total records
      params["rows"].to_i,#rows per page
      params["page"].to_i)#current page
  end
  
  def filter_bar_conditions(fields,params)
    conditions = ""
    fields.each do |field|
      conditions << "#{field} LIKE '%#{params[field]}%' AND " unless params[field].nil?
    end
    conditions.chomp("AND ")
  end
end
