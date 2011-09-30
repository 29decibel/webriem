#coding: utf-8
class Menu < ActiveRecord::Base
  belongs_to :menu_category
  validates_uniqueness_of :name

  has_and_belongs_to_many :roles

end
