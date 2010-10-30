#coding: utf-8
class AjaxServiceController < ApplicationController
  def getfee
    #travel relate
    fee_standard=FeeStandard.joins(:fee).where("region_type_id=? and fees.code=? and person_type_id=? and duty_id=?",params[:region_type_id],params[:fee_code],params[:pt],params[:duty_id])
    if fee_standard.count==0
      fee_standard=FeeStandard.joins(:fee).where("region_type_id=? and fees.code=? and (person_type_id=? or duty_id=?)",params[:region_type_id],params[:fee_code],params[:pt],params[:duty_id])
      if fee_standard.count==0
        fee_standard=FeeStandard.joins(:fee).where("region_type_id=? and fees.code=?",params[:region_type_id],params[:fee_code])
      end
    end    
    render :json=>fee_standard.count==0 ? "暂时没有".to_json : "#{fee_standard.first.amount},#{fee_standard.first.currency.id},#{fee_standard.first.currency},#{fee_standard.first.currency.default_rate}".to_json
    #"#{fee_standard.first.amount},#{fee_standard.first.currency.id},#{fee_standard.first.currency},#{fee_standard.first.currency.default_rate}"
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
