#coding: utf-8
class Person < ActiveRecord::Base
  belongs_to :dep, :class_name => "Dep", :foreign_key => "dep_id"
  belongs_to :duty, :class_name => "Duty", :foreign_key => "duty_id"
  belongs_to :boss, :class_name => "Person", :foreign_key => "boss_id"
  validates_presence_of :duty
  enum_attr :gender, [['男', 0], ['女', 1]]
end
