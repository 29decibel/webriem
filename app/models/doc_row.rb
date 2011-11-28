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

  scope :year,        lambda {|year| where("year(apply_date)=?",year)}
  scope :month,       lambda {|month| where("month(apply_date)=?",month)}
  scope :with_fee,    lambda {|fee| where("fee_id=?",fee.try(:id)||fee)}
  scope :with_person, lambda {|person| where("person_id=?",person.try(:id)||person)}
  scope :valid,       where("doc_state!='un_submit' and doc_state!='rejected'")

  def set_person_dep_id
    if person
      self.person_dep_id = person.dep_id
    end
  end

  def resource_type_name
    I18n.t("common_attr.#{self.resource_type}")
  end
end
