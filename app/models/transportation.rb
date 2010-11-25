#coding: utf-8
class Transportation < ActiveRecord::Base
  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  def to_s
    "#{name}"
  end
end
