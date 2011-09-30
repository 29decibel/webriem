#coding: utf-8
module ApplicationHelper
  def reference_select(field_name,model_name,options={})
    html=""
    if options[:f]
      html<<options[:f].hidden_field(field_name.to_sym,{:value=>options[:value],:class=>"ref_hidden_field"})
    else
      html<<hidden_field_tag(field_name,options[:value],:class=>"ref_hidden_field")
    end
    html<<text_field_tag("#{model_name}_info",options[:text],:class=>"ref")
    html<<link_to(content_tag(:span,"",:class=>"reference"),"#",{"class-data"=>model_name})
    content_tag(:div,raw(html),:class=>"reference")
  end
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
  def link_to_add_fields(name, f, association,default_values=[])
    new_object = f.object.class.reflect_on_association(association).klass.new
    #set the default values
    default_values.each do |default_attr|
      new_object.send("#{default_attr}=",f.object.send("#{default_attr}")) if f.object.respond_to? default_attr and new_object.respond_to? default_attr
    end
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    #注意了兄弟们,在这里一定要去掉h()对整个文本的转义,否则就会js报错啦~~~~
    link_to_function(image_tag("/images/icons/add.png"), "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")",:class=>"detail_link")
  end
  def doc_type_name(num)
    num=num.to_i if num.class==String
    DOC_TYPES[num]
  end
  #get the current request uri
  def current_uri
    request.request_uri
  end
  DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"交际费报销",11=>"加班费报销",12=>"普通费用报销",13=>"福利费用报销",14=>"固定资产单据"}
  #to display a nice format date
  def display_date(input_date)
    return '' if input_date==nil
    input_date.strftime("%Y-%m-%d")
  end
  #=============mini button github style=======
  def mini_link_to
     #href="javascript:;" class="minibutton"><span>Basic Button</span></a>
  end
  def mini_link_to_function
    
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
  

end
