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
    conditions = filter_bar_conditions(opt,params)
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
      opt[:colModel],#fields
      row_count,#total records
      params["rows"].to_i,#rows per page
      params["page"].to_i)#current page
  end
  
  def filter_bar_conditions(opt,params)
    search_fields=opt[:search_fields]
    conditions = ""
    opt[:colModel].each do |col_model|
      #change the seleted column name if relation
      s_field = col_model[:name]
      if search_fields[s_field.to_sym]
        s_field = search_fields[s_field.to_sym] 
      end
      #change the compare LIKE value if enum
      value = params[col_model[:name]]
      if value
        if col_model[:enum_type]
          enum_hash = eval(col_model[:enum_type])
          enum_a = enum_hash.select {|k,v| v.include? value}
          puts value
          puts enum_a
          value = (enum_a and enum_a.size>0) ? enum_a.keys[0] : -119
          puts value
          conditions << "#{s_field} = '#{value}' AND "
          next
        end
        conditions << "#{s_field} LIKE '%#{value}%' AND "
      end
    end
    conditions.chomp("AND ")
  end
end
