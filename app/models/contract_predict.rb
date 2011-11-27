#coding: utf-8
class ContractPredict < ActiveRecord::Base
  has_paper_trail
  belongs_to :vrv_project
  validates_presence_of :product,:package_num,:points,:price,:sign_date,:bill_percent
  BILL_PERCENT = %w(50%以下 50%-80% 80%以上)

  validates :bill_percent,:inclusion => BILL_PERCENT
end
