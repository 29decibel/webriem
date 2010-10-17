#coding: utf-8
class RdTravel < ActiveRecord::Base
  belongs_to :reim_detail
  belongs_to :fee_standard
  belongs_to :region
end
