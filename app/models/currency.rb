#coding: utf-8
class Currency < ActiveRecord::Base
  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  def to_s
    "#{name}"
  end
  def other_info
    default_rate
  end
end
