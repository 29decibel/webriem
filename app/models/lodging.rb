#coding: utf-8
class Lodging < ActiveRecord::Base
  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  def to_s
    "#{name};#{code}"
  end
end
