#coding: utf-8
class Subject < ActiveRecord::Base
  belongs_to :fee
  belongs_to :dep
  blongs_to_name_attr :fee
  blongs_to_name_attr :dep
  enum_attr :busitype,[['借款',0],['报销',1],['其他',2]]
end
