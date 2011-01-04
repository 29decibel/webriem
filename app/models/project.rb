#coding: utf-8
class Project < ActiveRecord::Base
  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  def to_s
    "#{code};#{name}"
  end
end
