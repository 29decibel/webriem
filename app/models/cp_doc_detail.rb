#coding: utf-8
class CpDocDetail < ActiveRecord::Base
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"
  belongs_to :dep
  belongs_to :fee
  belongs_to :project
  belongs_to :currency
  def after_initialize
    self.currency=Currency.find_by_code("001")
    self.rate=Currency.find_by_code("001").default_rate
  end
end
