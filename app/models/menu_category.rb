class MenuCategory < ActiveRecord::Base
  has_many :menus,:class_name=>"Menu",:foreign_key=>"menu_category_id"
  def grouped_menus
    count=0
    g_menus=[]
    menus.each do |m|
      array_count=g_menus.count
      if g_menus[array_count-1] and g_menus[array_count-1].count<5
        g_menus[array_count-1]<<m
      else
        g_menus<<[m]
      end
    end
    g_menus
  end
end
