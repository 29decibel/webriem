#coding: utf-8
class Dep < ActiveRecord::Base
  has_many :sub_deps, :class_name => "Dep",:foreign_key => "parent_dep_id"
  belongs_to :parent_dep, :class_name => "Dep",:foreign_key => "parent_dep_id"
  blongs_to_name_attr :parent_dep
  validates_presence_of :name,:code,:start_date
  validates_uniqueness_of :name,:code
  has_many :people, :class_name => "Person", :foreign_key => "dep_id"
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
end
