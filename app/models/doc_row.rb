#coding: utf-8
class DocRow < ActiveRecord::Base
  DocResourceTypes = 
    {'借款单据'=>'CpDocDetail','差旅费'=>'RdTravel',
    '交通费'=>'RdCommonTransport','住宿费'=>'RdLodging','其它费用'=>'OtherRiem','交际费用'=>'RdWorkMeal',
    '工作餐费'=>'RdWorkMeal','福利费用'=>'RdBenefit','加班车费'=>'RdExtraWorkCar','加班餐费'=>'RdExtraWorkMeal'}
  belongs_to :person
  belongs_to :dep
  belongs_to :project
  before_save :set_person_dep_id
  def set_person_dep_id
    if person
      self.person_dep_id = person.dep_id
    end
  end
end
