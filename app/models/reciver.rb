#coding: utf-8
class Reciver < ActiveRecord::Base
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"
  belongs_to :settlement, :class_name => "Settlement", :foreign_key => "settlement_id"
  blongs_to_name_attr :settlement
  validates_presence_of :amount
  validates_presence_of :company
  validates_presence_of :bank_no
  validates_presence_of :settlement_id
  validates_presence_of :bank
end
