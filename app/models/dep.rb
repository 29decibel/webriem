#coding: utf-8
class Dep < ActiveRecord::Base
  has_many :sub_deps, :class_name => "Dep",:foreign_key => "parent_dep_id"
  belongs_to :parent_dep, :class_name => "Dep",:foreign_key => "parent_dep_id"
  validates_presence_of :name,:code,:start_date,:end_date, :message => "不能为空"
  validates_uniqueness_of :name,:code, :message=>"已经存在"
  has_many :people, :class_name => "Person", :foreign_key => "dep_id"
end
