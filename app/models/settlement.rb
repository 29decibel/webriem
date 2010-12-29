#coding: utf-8
class Settlement < ActiveRecord::Base
  validates_presence_of :name,:code
  validates_uniqueness_of :name,:code
  netzke_exclude_attributes :created_at, :updated_at
  def to_s
    "#{name}"
  end
end
