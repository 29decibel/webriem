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
      #Default Grid opt End
      
      opt[:pager_opt] = {}
      #Default Pager options Begin
      opt[:pager_opt][:edit] ||= false
      opt[:pager_opt][:add] ||= false
      opt[:pager_opt][:del] ||= false
      opt[:pager_opt][:search] ||= false
      opt[:pager_opt][:refresh] ||= true
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
          var main_grid = jQuery('##{opt[:id]}').jqGrid(
            #{opt.to_json(:exclude => [:pager_opt,:columns,:id]).release_js}
          );
          
          main_grid.navGrid('##{opt[:id]}_pager',
          #{opt[:pager_opt].to_json(:exclude =>[:editoptions,:addoptions,:deleteoptions,:searchoptions])},
          {#{opt[:pager_opt][:editoptions]}},
          {#{opt[:pager_opt][:addoptions]}},
          {#{opt[:pager_opt][:deleteoptions]}},
          {#{opt[:pager_opt][:searchoptions]}}
          );
          
          //main_grid.filterToolbar();
          
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
      if opt[:columns] and !opt[:columns].empty?
        column_models = opt[:columns].map do |col|
          if col.is_a? String or col.is_a? Symbol
            {:name=>col,:label =>model.human_attribute_name(col)}
          else
            {:name=>col[:name],:label=>col[:label] || model.human_attribute_name(col[:name])}.merge col
          end
        end
      else
        model.column_names.each do |col|
          column_models << {:name => col,:label =>model.human_attribute_name(col)}
        end
      end
      #get select and joins
      select=["distinct #{model.table_name}.id as id"]
      joins = []
      joins << opt[:joins] if opt[:joins]
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
        else
          select<<"#{model.table_name}.#{field} as #{col_model[:name]}"
        end
      end
      #return the final result
      {:columns=>column_models,
       :colNames=>column_models.collect {|col| col[:label]},
       :colModel=>column_models.collect {|col| {:name=>col[:name],:index=>col[:name]}},
       :select=>select,
       :joins=>joins}
    end

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
          value_a << row.send(col[:getter])
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