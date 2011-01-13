#coding: utf-8
# Rails-jqgrid
#Give it a grid name, everything else is optional.

#Current Tasks
# Need an on click function for rows
module ActionView
  module Helpers
    # jqgrid Dep,:fields=>'code,name'
    def jqgrid(name,opt={})
      model=eval(opt[:model]) if opt[:model]
      #Random HTML id
      opt[:id] = name
      #Default Grid options Begin ,make a merge of the fields
      #opt[:fields] ||= model.column_names.to_s
      opt[:caption] ||= model.human_name #here i use the human_name for the i18n reason
      id = opt[:caption].parameterize
      opt[:url] ||=  %Q(/grid_data/from_model?widget_id=#{opt[:id]})
      #others
      opt[:datatype] ||= "json"
      opt.merge! get_column_models(model,opt)
      opt[:pager] ||= "##{opt[:id]}_pager" #The '#' at the start marks the string as a function, else it will be a string in json
      opt[:rowNum] ||= 20
      opt[:rowList] ||= [20,40,60]
      opt[:viewrecords] ||= true
      opt[:rownumbers] ||= false
      opt[:hidegrid] ||=false
      opt[:autowidth] ||=true
      opt[:autoheight] ||=true
      #Default Grid opt End
      
      opt[:pager_opt] = {}
      #Default Pager options Begin
      opt[:pager_opt][:edit] ||= false
      opt[:pager_opt][:add] ||= false
      opt[:pager_opt][:del] ||= false
      opt[:pager_opt][:search] ||= false
      opt[:pager_opt][:refresh] ||= false
      opt[:pager_opt][:view] ||= false
      opt[:pager_opt][:editoptions] ||= ""
      opt[:pager_opt][:addoptions] ||= ""
      opt[:pager_opt][:deleteoptions] ||= ""
      opt[:pager_opt][:searchoptions] ||= ""
      #Default Pager options End
      #put every opt thing into session
      puts "puts session =========================="
      session[opt[:id]]=opt
      puts "end =========================="
      puts session[opt[:id]] 
      puts opt[:id]
      #Grid Javascript Begin
      raw %Q(
        <script type="text/javascript">
        
          jQuery(document).ready(function(){
          var main_grid = jQuery("##{opt[:id]}").jqGrid(
            #{opt.to_json(:exclude => [:pager_opt,:columns,:id]).release_js}
          );
          
          main_grid.navGrid('##{opt[:id]}_pager',
          #{opt[:pager_opt].to_json(:exclude =>[:editoptions,:addoptions,:deleteoptions,:searchoptions])},
          {#{opt[:pager_opt][:editoptions]}},
          {#{opt[:pager_opt][:addoptions]}},
          {#{opt[:pager_opt][:deleteoptions]}},
          {#{opt[:pager_opt][:searchoptions]}}
          );
          // two buttons filter and clear filter
          jQuery("##{opt[:id]}").jqGrid('navButtonAdd',"##{opt[:id]}_pager",{caption:"显示/隐藏过滤栏",title:"显示/隐藏过滤栏", buttonicon :'ui-icon-pin-s',
          	onClickButton:function(){
          		main_grid[0].toggleToolbar();          		
          	} 
          });
          jQuery("##{opt[:id]}").jqGrid('navButtonAdd',"##{opt[:id]}_pager",{caption:"清除过滤",title:"清除过滤",buttonicon :'ui-icon-refresh',
          	onClickButton:function(){
          		main_grid[0].clearToolbar();
          	} 
          });
          //the filter toolbar
          jQuery("##{opt[:id]}").jqGrid('filterToolbar',{stringResult: false,searchOnEnter : true});     
        });
        </script>
        <div class="jqgrid">
      		<table id="#{opt[:id]}" class="scroll ui-state-default" cellpadding="0" cellspacing="0"></table>
          <div id="#{opt[:id]}_pager" class="scroll" style="text-align:center;"></div>
      	</div>
      )
      #Grid Javascript End
    end
    #*************the definition of column model
    # [{:name=>"person",:label=>"人元"}]
    #*************get the select and joins
    #give a dep__name will cause a 
    #select : deps.name as dep__name 
    #joins : dep
    def get_column_models(model,opt)
      column_models=[]
      #get column models first
      #according to the given colModel,combine a new one
      if opt[:colModel] and !opt[:colModel].empty?
        column_models = opt[:colModel].map do |col|
          if col.is_a? String or col.is_a? Symbol
            {:name=>col,:label =>model.human_attribute_name(col)}
          else
            {:name=>col[:name],:label=>col[:label] || model.human_attribute_name(col[:name])}.merge col
          end
        end
      else
        model.column_names.each do |col|
          #hide id ,created_at,updated_at
          filter_field=["created_at","updated_at"]
          next if filter_field.include? col
          if col=="id"
            column_models << {:name => col,:hidden=>true}
          else
            column_models << {:name => col,:label =>model.human_attribute_name(col)}
          end
        end
      end
      #get select and joins
      select=["distinct #{model.table_name}.id as id"]
      joins = []
      joins << opt[:joins] if opt[:joins]
      #for the sql search field
      search_fields={}
      column_models.each do |col_model|
        relation,field = col_model[:name].split('__')
        if field==nil
          field=relation
          relation=nil          
        end
        #set the select
        if relation
          joins<<relation.to_sym
          join_table=eval(model.reflect_on_association(relation.to_sym).class_name).table_name
          select<<"#{join_table}.#{field} as #{col_model[:name]}"
          search_fields[col_model[:name].to_sym] = "#{join_table}.#{field}"
        else
          #this if condition considering the virtual column
          if model.column_names.include? col_model[:name]
            select<<"#{model.table_name}.#{field} as #{col_model[:name]}" 
            search_fields[col_model[:name].to_sym] = "#{model.table_name}.#{field}" #set the search field
          end
        end
      end
      #return the final result
      #this colModel is rich model which contains almost everything that a column need, not only the jqgrid client
      #such as :getter option , which is used for the server getting display value
      {:colNames=>column_models.collect {|col| col[:label]},
       :colModel=>column_models,
       :select=>select,
       :joins=>joins,
       :search_fields=>search_fields}
    end
    
    #init the scripts of jqgrid widget
    def jqgrid_init(locale="cn")
      #includes = capture { stylesheet_link_tag "jqgrid/#{theme}/jquery-ui-1.7.2.custom" }
      #includes << capture { stylesheet_link_tag "jqgrid/ui.jqgrid" }
      includes = capture { javascript_include_tag "jqgrid/jquery-1.4.2.min" }
      includes << capture { javascript_include_tag "jqgrid/i18n/grid.locale-#{locale}" }
      includes << capture { javascript_include_tag "jqgrid/jquery.jqGrid.min" }      
      includes
    end
  end
end

module JqgridJson
  
  def to_jqgrid_json(column_models,total_rows,per_page,current_page)    
    jqgrid = {}
    total_pages = (total_rows/per_page)+1
    jqgrid[:page] = current_page
    jqgrid[:records] = total_rows
    jqgrid[:total] = total_pages
    
    rows = []
    each do |row|
      value_a = []
      column_models.each do |col|
        if col[:getter]
          if row.respond_to? col[:getter].to_sym
            value_a << row.send(col[:getter])
          else
            value_a << nil
          end
        else
          value_a << row[col[:name]]
        end
      end
      rows << {:id => row.id, :cell => value_a}
    end
    
    jqgrid[:rows] = rows
    jqgrid.to_json    
  end
  
end

class Array
  include JqgridJson
  def to_s
    str = ""
    each do |value|
      str << value + ","  
    end
    str.chop!
    str
  end
end

class String
  def release_js
    result = self.sub("\"#--","").sub("--#\"","")
    result
  end
#  def to_json(options = nil)
#    #If the '#' symbol is the first character, this is a json function
#    #Return without the first '#' or parenthesis
#    if self.at(0) == '#'
#      self.sub(/(#)/,'')
#    else
#    #Otherwise use the original definition from the ActiveSupport library
#    #Which will make it a json string
#      json = '"' + gsub(ActiveSupport::JSON::Encoding.escape_regex) { |s|
#        ActiveSupport::JSON::Encoding::ESCAPED_CHARS[s]
#      }
#      json.force_encoding('ascii-8bit') if respond_to?(:force_encoding)
#      json.gsub(/([\xC0-\xDF][\x80-\xBF]|
#              [\xE0-\xEF][\x80-\xBF]{2}|
#              [\xF0-\xF7][\x80-\xBF]{3})+/nx) { |s|
#                s.unpack("U*").pack("n*").unpack("H*")[0].gsub(/.{4}/, '\\\\u\&')
#      } + '"'
#    end
#  end
end