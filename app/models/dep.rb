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
  #===================================================================================
  CUSTOM_QUERY={
      'parent_dep_id'=>{:include=>:parent_dep,:conditions=>'parent_deps_deps.name like ?'},
  }
  def self.custom_query(column_name,filter_text)
    if CUSTOM_QUERY.has_key? column_name
      CUSTOM_QUERY[column_name]
    else
      nil
    end
  end
  class<<self
    def ref_noshow
      ["version","start_date","end_date","u8dep_code","parent_dep_id"]
    end
  end
  #===================================================================================
  def to_s
    "#{name}"
  end
end
