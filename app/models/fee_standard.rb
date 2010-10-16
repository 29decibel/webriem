#coding: utf-8
class FeeStandard < ActiveRecord::Base
  belongs_to :project
  belongs_to :region
  belongs_to :duty
  belongs_to :lodging
  belongs_to :transportation
  blongs_to_name_attr :project
  blongs_to_name_attr :region
  blongs_to_name_attr :duty
  blongs_to_name_attr :lodging
  blongs_to_name_attr :transportation
  enum_attr :busitype,[['借款',0],['报销',1],['其他',2]]
  cattr_reader :per_page
  @@per_page = 10
end
