#coding: utf-8
class Menu < ActiveRecord::Base
  scope :solo,where("group_name is null or group_name=''")
  scope :has_group,where("group_name is not null and group_name!=''")

  validates_uniqueness_of :name

  has_and_belongs_to_many :roles

end
