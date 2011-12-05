#coding: utf-8
class Dep < ActiveRecord::Base
  has_many :sub_deps, :class_name => "Dep",:foreign_key => "parent_dep_id"
  belongs_to :parent_dep, :class_name => "Dep",:foreign_key => "parent_dep_id"
  belongs_to :u8_dep, :class_name => "U8Dep", :foreign_key => "u8_dep_id"
  validates_presence_of :name,:code,:start_date
  validates :code,:uniqueness=>{:scope=>:version}
  has_many :people, :class_name => "Person", :foreign_key => "dep_id"

  after_save :update_person_factors

  def to_s
    "#{name}"
  end

  def org
    o = self.organization
    p_dep = self.parent_dep
    while o.blank? and p_dep
      o = p_dep.organization
      p_dep = p_dep.parent_dep
    end
    o
  end

  private
  def update_person_factors
    people.each {|p| p.save}
  end
end
