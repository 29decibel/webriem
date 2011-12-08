#coding: utf-8
class Product < ActiveRecord::Base
  has_and_belongs_to_many :network_conditions
  scope :software,where('p_type=?','纯软件')
  scope :hardware,where('p_type=?','含硬件')
end
