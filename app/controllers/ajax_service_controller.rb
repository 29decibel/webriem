#coding: utf-8
class AjaxServiceController < ApplicationController
  def getfee
    region_type_id=Region.find(params[:region_id]).region_type_id
    fee_standard=FeeStandard.where("region_type_id=? and duty_id=?",region_type_id,params[:duty_id]).first
    render :json=>fee_standard==nil ? "暂时没有":fee_standard.amount
  end
  def remove_offset
    @doc_head=DocHead.find(params[:reim_doc_head_id].to_i)
    #add back the amount
    rp_doc=DocHead.find(params[:cp_doc_head_id].to_i)
    rp_offset=RiemCpOffset.where("cp_doc_head_id = ? and reim_doc_head_id= ? ",params[:cp_doc_head_id].to_i,params[:reim_doc_head_id].to_i).first
    rp_doc.update_attribute(:cp_doc_remain_amount,rp_doc.cp_doc_remain_amount+rp_offset.amount)
    rp_offset.destroy
    @message="成功去除"
    render "shared/show_result"
  end

end
