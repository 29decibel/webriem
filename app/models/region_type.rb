#coding: utf-8
class RegionType < ActiveRecord::Base
  validates_uniqueness_of :name
  def to_s
    "#{name}"
  end
end
