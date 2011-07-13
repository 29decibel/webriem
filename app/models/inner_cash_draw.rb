#coding: utf-8
class InnerCashDraw < ActiveRecord::Base
  belongs_to :account
  belongs_to :doc_head
  has_many :cash_draw_items, :class_name => "CashDrawItem", :foreign_key => "inner_cash_draw_id"
  def total_amount
    self.cash_draw_items.sum do |item|
     if item
       item.apply_amount
     else
       0
     end
    end
  end
  accepts_nested_attributes_for :cash_draw_items , :allow_destroy => true
  def amount
    apply_amount
  end
end
