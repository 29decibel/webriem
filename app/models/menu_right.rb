#coding: utf-8
class MenuRight < ActiveRecord::Base
  belongs_to :menu
  belongs_to :role
  netzke_exclude_attributes :created_at, :updated_at
end
