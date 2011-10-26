#coding: utf-8
class FeeStandard < ActiveRecord::Base
  belongs_to :project
  belongs_to :region_type
  belongs_to :duty
  belongs_to :lodging
  belongs_to :transportation
  belongs_to :business_type
  belongs_to :currency
  belongs_to :fee
  belongs_to :person_type

  validates_presence_of :fee_id

  def to_s
    "#{name}"
  end
end
