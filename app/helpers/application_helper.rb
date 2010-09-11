module ApplicationHelper
  def mark_required(object, attribute)  
      if object.class.validators_on(attribute).map(&:class).include? ActiveModel::Validations::PresenceValidator
        "required"
      else
        ""
      end
  end
end
