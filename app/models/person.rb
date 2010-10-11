#coding: utf-8
class Person < ActiveRecord::Base
  belongs_to :dep, :class_name => "Dep", :foreign_key => "dep_id"
  belongs_to :duty, :class_name => "Duty", :foreign_key => "duty_id"
  belongs_to :boss, :class_name => "Person", :foreign_key => "boss_id"
  validates_presence_of :duty_id,:name,:code,:phone,:e_mail,:ID_card,:bank_no,:bank
  validates_uniqueness_of :name,:code,:phone,:e_mail,:ID_card,:bank_no
  enum_attr :gender, [['未知',0],['男', 1], ['女', 2]]
  blongs_to_name_attr :dep
  blongs_to_name_attr :duty
end
