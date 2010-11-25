#coding: utf-8
class CashDrawItem < ActiveRecord::Base
  belongs_to :inner_cash_draw, :class_name => "InnerCashDraw", :foreign_key => "inner_cash_draw_id"
end
