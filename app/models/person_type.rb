#coding: utf-8
class PersonType < ActiveRecord::Base
  validates_uniqueness_of :name
end
