#coding: utf-8
module ApplicationHelper
  def mark_required(object, attribute)  
      if object.class.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
        "required"
      else
        ""
      end
  end
  #function to remove a link
  def link_to_remove(name,f)
    link_to_function(name,"remove_fields(this)")
  end
  #add fields to current form
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    #注意了兄弟们,在这里一定要去掉h()对整个文本的转义,否则就会js报错啦~~~~
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")")
  end
  def doc_type_name(num)
    num=num.to_i if num.class==String
    DOC_TYPES[num]
  end
  #get the current request uri
  def current_uri
    request.request_uri
  end
  DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"工作餐费报销",11=>"加班费报销",12=>"业务交通费报销",13=>"福利费用报销"}
  #used for search engine
  def searchable_columns(class_object)
    class_object.columns.select{|c| !(%w[id created_at updated_at].include? c.name) and !(class_object.respond_to?(:not_display) and class_object.not_display.include?(c.name))}
  end
  #get the column value of the object
  def get_display_value(result_obj,column)
    ass=result_obj.class.reflect_on_all_associations.select{|a| a.primary_key_name==column.name and a.macro==:belongs_to}
    if ass and ass.count>0
      eval("result_obj.#{ass.first.name}_name")
    else
      result_obj.send(column.name)
    end
  end
end
