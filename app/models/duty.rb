#coding: utf-8
class Duty < ActiveRecord::Base
  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  #people which have such duty
  has_many :people, :class_name => "Person", :foreign_key => "duty_id"
  has_and_belongs_to_many :work_flows
  def to_s
    "#{name}"
  end
end
