#coding: utf-8
class Role < ActiveRecord::Base
  def menus
    return [] if menu_ids==nil
    Menu.where(:id=>menu_ids.split(',')).all
  end
  def have_right? menu_id
    return false if menu_ids==nil
    return menu_ids.split(',').include?(menu_id.to_s)
  end
  #def self.cool
  #  Role.all.each do |r|
  #    ms=MenuRight.where("role_id = ?",r.id).all.map {|mr| mr.menu.id }
  #    r.menu_ids=ms.join(",")
  #    r.save
  #  end
  #end
  def to_s
    "#{name}"
  end
end
