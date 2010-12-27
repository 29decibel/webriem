# Rails-jqgrid
#Give it a model, everything else is optional.

#Current Tasks
# Need an on click function for rows
module ActionView
  module Helpers
    # jqgrid Dep,:fields=>'code,name'
    def jqgrid(model,opt={})
      
      #Random HTML id
      opt[:id] ||= model.to_s.pluralize + '_' + rand(36**4).to_s(36)
      
      #Default Grid options Begin ,make a merge of the fields
      opt[:fields] ||= model.column_names.to_s
      opt[:caption] ||= model.human_name #here i use the human_name for the i18n reason
      id = opt[:caption].parameterize
      opt[:url] ||=  %Q(/grid_data/from_model?model=#{model.to_s}&fields=#{opt[:fields]})
      opt[:datatype] ||= "json"
      opt[:colNames] ||= opt[:fields].split(",").collect {|col| model.human_attribute_name col}
      opt[:colModel] ||= fields_to_colmodel(opt[:fields])
      opt[:pager] ||= "##{opt[:id]}_pager" #The '#' at the start marks the string as a function, else it will be a string in json
      opt[:rowNum] ||= 20
      opt[:rowList] ||= [20,40,60]
      opt[:viewrecords] ||= true
      opt[:ondblClickRow] ||= '#function(rowId, iRow, iCol, e) { alert(rowId);}'
      #if(rowId){ window.location = '#{model.name.pluralize}/show/}' + rowId;
      #Default Grid opt End
      
      opt[:pager_opt] = {}
      #Default Pager options Begin
      opt[:pager_opt][:edit] ||= true
      opt[:pager_opt][:add] ||= true
      opt[:pager_opt][:del] ||= true
      opt[:pager_opt][:search] ||= true
      opt[:pager_opt][:refresh] ||= true
      opt[:pager_opt][:view] ||= true
      opt[:pager_opt][:editoptions] ||= ""
      opt[:pager_opt][:addoptions] ||= ""
      opt[:pager_opt][:deleteoptions] ||= ""
      opt[:pager_opt][:searchoptions] ||= ""
      #Default Pager options End
      
      #Grid Javascript Begin
      raw %Q(
        <script type="text/javascript">
        
          jQuery(document).ready(function(){
          var main_grid = jQuery('##{opt[:id]}').jqGrid(
            #{opt.to_json(:exclude => [:pager_opt,:fields,:id])}
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
    
    def fields_to_colmodel(fields)
      fields_a = fields.split(",")
      colmodel = []
      fields_a.each do |field|
        colmodel << {:name => field,:index =>field}
      end
      colmodel
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
  
  def to_jqgrid_json(fields,total_rows,per_page,current_page)
    
    jqgrid = {}
    total_pages = (total_rows/per_page)+1
    jqgrid[:page] = current_page
    jqgrid[:records] = total_rows
    jqgrid[:total] = total_pages
    
    fields_a = fields.split(",")
    
    rows = []
    each do |row|
      value_a = []
      fields_a.each do |field|
        value_a << row[field]
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
  def to_json(options = nil)
    #If the '#' symbol is the first character, this is a json function
    #Return without the first '#' or parenthesis
    if self.at(0) == '#'
      self.sub(/(#)/,'')
    else
    #Otherwise use the original definition from the ActiveSupport library
    #Which will make it a json string
      json = '"' + gsub(ActiveSupport::JSON::Encoding.escape_regex) { |s|
        ActiveSupport::JSON::Encoding::ESCAPED_CHARS[s]
      }
      json.force_encoding('ascii-8bit') if respond_to?(:force_encoding)
      json.gsub(/([\xC0-\xDF][\x80-\xBF]|
              [\xE0-\xEF][\x80-\xBF]{2}|
              [\xF0-\xF7][\x80-\xBF]{3})+/nx) { |s|
                s.unpack("U*").pack("n*").unpack("H*")[0].gsub(/.{4}/, '\\\\u\&')
      } + '"'
    end
  end
end