#coding: utf-8
class AjaxServiceController < ApplicationController
  def getfee
    region_type_id=Region.find(params[:region_id]).region_type_id
    fee_standard=FeeStandard.where("region_type_id=? and duty_id=?",region_type_id,params[:duty_id]).first
    render :json=>fee_standard==nil ? "暂时没有":fee_standard.amount
  end

end
