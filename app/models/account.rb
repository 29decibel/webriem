#coding: utf-8
class Account < ActiveRecord::Base
  validates_presence_of :name,:account_no
  validates_uniqueness_of :name,:account_no
  netzke_exclude_attributes :created_at, :updated_at
  def to_s
    "#{name};#{account_no}"
  end
end
