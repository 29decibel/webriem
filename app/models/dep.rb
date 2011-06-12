#coding: utf-8
class Dep < ActiveRecord::Base
  has_many :sub_deps, :class_name => "Dep",:foreign_key => "parent_dep_id"
  belongs_to :parent_dep, :class_name => "Dep",:foreign_key => "parent_dep_id"
  belongs_to :u8_dep, :class_name => "U8Dep", :foreign_key => "u8_dep_id"
  blongs_to_name_attr :parent_dep
  blongs_to_name_attr :u8_dep
  validates_presence_of :name,:code,:start_date
  validates :code,:uniqueness=>{:scope=>:version}
  has_many :people, :class_name => "Person", :foreign_key => "dep_id"

  def to_s
    "#{name}"
  end
end
