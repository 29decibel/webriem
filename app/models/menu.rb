#coding: utf-8
class Menu < ActiveRecord::Base
  validates_uniqueness_of :name

  has_and_belongs_to_many :roles

end
