#coding: utf-8
class Menu < ActiveRecord::Base
  belongs_to :menu_category
  validates_uniqueness_of :name
  NOT_DISPLAY=['menu_type']
  def self.not_display
    NOT_DISPLAY
  end
  def to_s
    I18n.t "menu.#{name}"
  end
end
