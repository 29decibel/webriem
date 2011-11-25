#coding: utf-8
class ContractDoc < ActiveRecord::Base
  validates_presence_of :customer

  SOURCE = %w(直单 经销)
  validates :source,:inclusion => SOURCE
end
