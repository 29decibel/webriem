#coding: utf-8
module ApplicationHelper
  #token select control
  #model info
  #field name
  def ts(field_name,model_name,options={})
    #change value
    if options[:value]
      model=eval(model_name)
      model.include_root_in_json = false
      options[:value]=model.find(options[:value]).to_json
    end
    if options[:f]
      options[:f].text_field field_name.to_sym,"data-model"=>model_name,"data-pre"=>"[#{options[:value]}]",:class=>"token-input"
    else
      text_field_tag field_name.to_sym,'',"data-model"=>model_name,"data-pre"=>options[:value],:class=>"token-input"
    end
  end
  def error_css?(object,att)
    object and !object.errors[att].blank?
  end
  def mark_required(object, attribute)  
      if object.class.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
        "*"
      else
        ""
      end
  end
  #function to remove a link
  def link_to_remove
    link_to_function(image_tag('list-remove.png'),"remove_fields(this)",:class=>"detail_link")
  end
  #add fields to current form
  def link_to_add_fields(name, f, doc_relation,default_values=[])
    dr_meta = doc_relation.doc_row_meta_info
    association = eval(dr_meta.name).table_name
    new_object = eval(dr_meta.name).new
    #set the default values
    default_values.each do |default_attr|
      new_object.send("#{default_attr}=",f.object.send("#{default_attr}")) if f.object.respond_to? default_attr and new_object.respond_to? default_attr
    end
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      fields_str = ''
      doc_relation.doc_row_attrs.split(',').each do |col|
        fields_str << tb_field(builder,col)
      end
      raw fields_str
    end
    #注意了兄弟们,在这里一定要去掉h()对整个文本的转义,否则就会js报错啦~~~~
    link_to_function(image_tag("icons/add.png"), "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")",:class=>"detail_link")
  end
  #get the current request uri
  def current_uri
    request.request_uri
  end
  #to display a nice format date
  def display_date(input_date)
    return '' if input_date==nil
    input_date.strftime("%Y-%m-%d")
  end

  #====================================core stuff==================================================
  def default_rate
    1.0
  end

  def with_subdomain(subdomain='')
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, request.domain, request.port_string].join  
  end

  def tinput(f,col_name)
    col = f.object.class.columns.select{|c|c.name==col_name}.first
    results = ''
    klass = f.object.class
    results << 
    case col.type
    when :integer
      # belnogs_to
      ass = klass.reflect_on_all_associations(:belongs_to).select{|ass|ass.primary_key_name==col.name}.first
      if ass
        ts(col.name,ass.klass)
      else
        f.text_field(col_name)
      end
    when :string
      f.text_field(col_name)
    when :text
      f.text_area(col_name)
    when :decimal
      f.text_field(col_name)
    when :datetime
      f.datetime_select col_name,{},:class=>'small'
    when :date
      f.date_select col_name,{},:class=>'small'
    end
    raw results
  end

  def tb_field(f,col_name)
    content_tag :div,:class=>'clearfix' do
      f.label(col_name) +
      (content_tag :div,:class=>'input' do
        tinput(f,col_name)
      end)
    end
  end

end
