class InnerCashDraw < ActiveRecord::Base
  belongs_to :account
  belongs_to :doc_head
  has_many :cash_draw_items, :class_name => "CashDrawItem", :foreign_key => "inner_cash_draw_id"
  accepts_nested_attributes_for :cash_draw_items ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
end
