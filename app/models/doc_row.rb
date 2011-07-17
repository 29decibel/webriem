class DocRow < ActiveRecord::Base
  belongs_to :person
  before_save :set_person_dep_id
  def set_person_dep_id
    if person
      self.person_dep_id = person.dep_id
    end
  end
end
