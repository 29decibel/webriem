#coding: utf-8
class BillAfter < ActiveRecord::Base
  belongs_to :vrv_project

  BILL_STATE = %w(我方中标 我方为中标)
  CONTRACT = %w(合同正在协商中 合同内容已敲定，未签署 合同已经签署)
  MONEY_BACK = %w(一次付清 分批付款)

  validates :bill_state,:inclusion => BILL_STATE
  validates :contract,:inclusion => CONTRACT
  validates :money_back,:inclusion => MONEY_BACK
end
