#coding: utf-8
class Region < ActiveRecord::Base
  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  belongs_to :region_type
  blongs_to_name_attr :region_type
  #===================================================================================
  CUSTOM_QUERY={
      'region_type_id'=>{:include=>:region_type,:conditions=>'region_types.name like ?'},
  }
  def self.custom_query(column_name,filter_text)
    if CUSTOM_QUERY.has_key? column_name
      CUSTOM_QUERY[column_name]
    else
      nil
    end
  end
  def to_s
    "#{name}"
  end
end
