#coding: utf-8
class OtherRiem < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :currency
  validates_presence_of :rate
  validates_presence_of :currency_id
  validates_presence_of :description
  def amount
    fi_amount
  end
end
