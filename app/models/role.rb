#coding: utf-8
class Role < ActiveRecord::Base
  has_many :people, :class_name => "Person", :foreign_key => "role_id"
  has_many :menu_rights, :class_name => "MenuRight", :foreign_key => "role_id"  
  has_many :menus,:through => :menu_rights
  def to_s
    "#{name}"
  end
end
