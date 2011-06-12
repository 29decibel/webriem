#coding: utf-8
class Person < ActiveRecord::Base

  belongs_to :dep, :class_name => "Dep", :foreign_key => "dep_id"
  belongs_to :duty, :class_name => "Duty", :foreign_key => "duty_id"
  belongs_to :role, :class_name => "Role", :foreign_key => "role_id"
  belongs_to :person_type, :class_name => "PersonType", :foreign_key => "person_type_id"

  validates_presence_of :duty_id,:name,:code,:phone,:e_mail,:ID_card,:bank_no,:bank
  validates_uniqueness_of :name,:code,:phone,:e_mail,:ID_card,:bank_no

  def to_s
    "#{name}"
  end

  def gender_enum
    ['男','女']
  end
end
