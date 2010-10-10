#coding: utf-8
class Dep < ActiveRecord::Base
  has_many :sub_deps, :class_name => "Dep",:foreign_key => "parent_dep_id"
  belongs_to :parent_dep, :class_name => "Dep",:foreign_key => "parent_dep_id"
  validates_presence_of :name,:code,:start_date
  validates_uniqueness_of :name,:code
  has_many :people, :class_name => "Person", :foreign_key => "dep_id"
end
