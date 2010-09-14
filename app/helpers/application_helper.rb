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
end
