#coding: utf-8
class Settlement < ActiveRecord::Base

  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  belongs_to :ccode,:class_name=>'U8code',:foreign_key=>'u8code_id'

  def to_s
    "#{name}"
  end

end
