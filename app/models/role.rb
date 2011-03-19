#coding: utf-8
class Role < ActiveRecord::Base
  def menus
    Menu.where(:id=>menu_ids.split(',')).all
  end
  def have_right? menu_id
    return false if menu_ids==nil
    return menu_ids.split(',').include?(menu_id.to_s)
  end
  def self.cool
    Role.all.each do |r|
      menu_a=r.menus.map {|m| m.id}
      r.menu_ids=menu_a.join(",")
      r.save
    end
  end
  def to_s
    "#{name}"
  end
end
