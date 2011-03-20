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
  def fcm
    return FeeCodeMatch.find_by_fee_code("03")
  end
  def project
    doc_head.project
  end
  def dep
    doc_head.afford_dep
  end
end
