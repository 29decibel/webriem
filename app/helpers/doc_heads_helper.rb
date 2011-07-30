#coding: utf-8
module DocHeadsHelper
  def can_adjust_amount(doc,person_type)
    doc.current_approver_id == current_user.person.id and
    current_user.person.person_type and 
    current_user.person.person_type.code == person_type and doc.processing?
  end
end
