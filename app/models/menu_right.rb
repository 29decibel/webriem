#coding: utf-8
class MenuRight < ActiveRecord::Base
  belongs_to :menu
  belongs_to :role
end
