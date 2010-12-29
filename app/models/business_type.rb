#coding: utf-8
class BusinessType < ActiveRecord::Base
  netzke_exclude_attributes :created_at, :updated_at
  validates_uniqueness_of :name
  def to_s
    "#{name}"
  end
end
