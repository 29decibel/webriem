#coding: utf-8
class Role < ActiveRecord::Base
  validates_presence_of :name
  has_and_belongs_to_many :menus

  def have_right? menu_id
    return false if menu_ids==nil
    return menu_ids.split(',').include?(menu_id.to_s)
  end

  def to_s
    "#{name}"
  end
end
