#coding: utf-8
class DocRow < ActiveRecord::Base
  DocResourceTypes = ['BorrowDocDetail',
      'PayDocDetail','RdTravel','RdTransport',
      'RdLodging','OtherRiem','RdCommunicate',
      'RdExtraWorkCar','RdExtraWorkMeal','CommonRiem',
      'RdWorkMeal','RdCommonTransport','RdBenefit']
  belongs_to :person
  belongs_to :dep
  belongs_to :project
  before_save :set_person_dep_id
  def set_person_dep_id
    if person
      self.person_dep_id = person.dep_id
    end
  end

  def resource_type_name
    I18n.t("common_attr.#{self.resource_type}")
  end
end
