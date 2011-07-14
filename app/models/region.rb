#coding: utf-8
class Region < ActiveRecord::Base
  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  belongs_to :region_type
  def to_s
    "#{name}"
  end
end
