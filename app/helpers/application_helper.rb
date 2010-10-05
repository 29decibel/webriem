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
    DOC_TYPES[num]
  end
  DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"报销单据",4=>"收款通知单",5=>"结汇申请单",6=>"转账申请",7=>"现金提取申请单",8=>"购买理财产品申请单",9=>"赎回理财产品申请单"}
end
