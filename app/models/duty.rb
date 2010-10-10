class Duty < ActiveRecord::Base
  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  #people which have such duty
  has_many :people, :class_name => "Person", :foreign_key => "duty_id"
end
