#coding: utf-8
class Duty < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  #people which have such duty
  has_many :people, :class_name => "Person", :foreign_key => "duty_id"
  has_and_belongs_to_many :work_flows
  after_save :update_person_factors

  def to_s
    "#{name}"
  end

  private
  def update_person_factors
    people.each {|p| p.save}
  end

end
