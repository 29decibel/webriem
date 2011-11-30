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
  def doc_state_css(doc)
    case doc.state
    when 'unsubmit'
      ''
    when 'approved'
      'notice'
    when 'paid'
      'success'
    when 'processing'
      'warning'
    when 'rejected'
      'important'
    end
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
    link_to_function(image_tag('list-remove.png'),"remove_fields(this)",:class=>"remove_doc_row")
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
      doc_relation.doc_row_attrs.each do |col|
        fields_str << tb_input_field(builder,col)
      end
      content_tag :div,:class=>'doc_row' do
        link_to_remove + builder.hidden_field(:_destroy,:class=>'destroy_mark') +raw(fields_str)
      end
    end
    #注意了兄弟们,在这里一定要去掉h()对整个文本的转义,否则就会js报错啦~~~~
    link_to_function(image_tag("icons/add.png"), "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")",:class=>"add_doc_row")
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

  def with_subdomain(subdomain='')
    subdomain = (subdomain || "")
    subdomain += "." unless subdomain.empty?
    [subdomain, request.domain, request.port_string].join  
  end

  def smart_select_field(f,col_name,validator,options={})
    collection = validator.options[:in]
    logger.info '^^^^^^^^^^^^ begin smart select ^^^^^^^^^^'
    if options[:as] == 'radio'
      content_tag :ul,:class=>'inputs-list' do
        collection.inject('') do |result,option|
          raw(result) + (content_tag :li do
            content_tag :label do
              f.radio_button(col_name,option) + (content_tag :span do
                option
              end)
            end
          end)
        end
      end
    else
      f.select col_name,collection,{ :include_blank => false }
    end
  end

  def tinput(f,col_name,options={})
    options[:class]="#{col_name}__input"

    ass = f.object.class.reflect_on_all_associations.select{|ass|ass.foreign_key==col_name}.first
    options[:ass] = ass

    if ass
      tb_association_field(f,col_name,options)
    else
      col = f.object.class.columns.select{|c|c.name==col_name}.first
      # set defualt class options 
      logger.info "###################{f.object.class}#{col_name}"
      case col.type
      when :integer
        f.text_field(col_name,options)
      when :string
        include_validator = f.object.class.validators_on(col_name).select{|v|v.class==ActiveModel::Validations::InclusionValidator}.first
        if include_validator
          smart_select_field(f,col_name,include_validator,options)
        else
          f.text_field(col_name,options)
        end
      when :text
        f.text_area(col_name,options)
      when :decimal
        f.text_field(col_name,options)
      when :datetime
        f.text_field col_name,:class=>"datetime_select #{options[:class]}"
      when :boolean
        f.check_box(col_name,options)
      when :date
        f.text_field col_name,:class=>"date_select #{options[:class]}"
      else
        f.text_field(col_name,options)
      end
    end
  end

  def currency_prepend(symbol,&block)
    content_tag :div,:class=>'input-prepend' do
      (content_tag :span,:class=>'add-on' do
        symbol
      end) + block.call
    end
  end

  def tb_input_field(f,col_name,options={})
    col = f.object.class.columns.select{|c|c.name==col_name}.first
    return if !col
    # error message
    error_msg = f.object.errors[col_name]
    # inline help message
    help = error_msg.first ? (content_tag :span,:class=>'help-inline' do
      error_msg.first
    end) : ''
    # value field
    value = (content_tag :div,:class=>'input' do
      logger.info '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
      logger.info f.object.class.name
      logger.info '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
      if f.object.class.respond_to?(:read_only_attr?) and f.object.class.try(:read_only_attr?,col_name)
        f.hidden_field(col_name) + 
        (content_tag :span,:class=>"uneditable-input #{col_name}__input" do
          _display_name(f,col_name)
        end)
      else
        if col and col.type==:decimal and col.scale==2
          currency_prepend '￥' do
            tinput(f,col_name) + help
          end
        else
          tinput(f,col_name,options) + help
        end
      end
    end)
    # combine
    content_tag :div,:class=>"#{f.object.class.name.underscore}__#{col_name} clearfix #{'error' if error_msg.count>0}" do
      f.label(I18n.t("activerecord.attributes.#{f.object.class.name.underscore}.#{col_name}")+mark_required(f.object,col_name)) + value
    end
  end

  def tb_association_field(f,col_name,options={})
    ass = options[:ass]
    case ass.macro
    when :belongs_to
      ts(col_name,ass.klass.name,:f=>f,:value=>f.object.try(col_name),:text=>f.object.try(ass.name).to_s)
    when :has_and_belongs_to_many
      content_tag :ul,:class=>'inputs-list' do
        eval(ass.class_name).all.inject('') do |result,record|
          raw(result) + (content_tag :li do
            content_tag :label do
              f.check_box("#{col_name}[]",record.id) + (content_tag :span do
                record.try(:name) if record.respond_to?(:name)
              end)
            end
          end)
        end
      end
    else
      f.text_field col_name,options
    end
  end

  def tb_has_many_field(f,col_name,options={})
    ass = f.object.class.reflect_on_all_associations.select{|ass|ass.name==col_name}.first
    value = (content_tag :ul,:class=>'inputs-list' do
      eval(ass.class_name).all.inject('') do |result,record|
        raw(result) + (content_tag :li do
          content_tag :label do
            check_box_tag("#{f.object.class.name.underscore}[#{ass.association_foreign_key}s][]", record.id, f.object.try(col_name).include?(record)) + (content_tag :span do
              record.try(:name) if record.respond_to?(:name)
            end)
          end
        end)
      end
    end)
    error_msg = f.object.errors[col_name]
    content_tag :div,:class=>"clearfix #{'error' if error_msg.count>0}" do
      f.label(I18n.t("activerecord.attributes.#{f.object.class.name.underscore}.#{col_name}")+mark_required(f.object,col_name)) + value
    end
  end

  def tb_show_field(obj,col_name,options={})
    col = obj.class.columns.select{|c|c.name==col_name}.first
    ass = obj.class.reflect_on_all_associations(:belongs_to).select{|ass|ass.foreign_key==col_name}.first
    content_tag :div,:class=>'row' do
      (content_tag :div,:class => (options[:label_css] || 'span4') do
        I18n.t("activerecord.attributes.#{obj.class.name.underscore}.#{col_name}")
      end) +
      (content_tag :div,:class => (options[:value_css] || 'span6') do
        if ass
          obj.send(ass.name).try(:name)
        elsif col and col.type==:decimal and col.scale==2
          "￥#{obj.send(col_name).try(:to_s)}"
        else
          obj.send(col_name).try(:to_s)
        end
      end)
    end
  end

  def nice_show(obj)
    descripts = []
    obj.class.column_names.each do |col_name|
      next if col_name=='vrv_project'
      value = obj.send(col_name)
      ass = obj.class.reflect_on_all_associations(:belongs_to).select{|ass|ass.foreign_key==col_name}.first
      if ass
        value = obj.send(ass.name).try(:name)
      end
      if !value.blank?
        descripts << [I18n.t("activerecord.attributes.#{obj.class.name.underscore}.#{col_name}"),value]
      end
    end
    descripts
  end

  private
  def _display_name(f,col_name)
    ass = f.object.class.reflect_on_all_associations(:belongs_to).select{|ass|ass.foreign_key==col_name}.first
    if ass
      f.object.send(ass.name).try(:name)
    else
      f.object.send(col_name).try(:to_s)
    end
  end

end
