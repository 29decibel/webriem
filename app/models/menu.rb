#coding: utf-8
class Menu < ActiveRecord::Base
  validates_uniqueness_of :name
  NOT_DISPLAY=['menu_type']
  def self.not_display
    NOT_DISPLAY
  end
  def to_s
    I18n.t "menu.#{name}"
  end
end
