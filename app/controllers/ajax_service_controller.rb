#coding: utf-8
class AjaxServiceController < ApplicationController
  def getfee
    fee_standard=nil
    #travel relate
    if !params[:pt].blank?
      fee_standard=FeeStandard.joins(:fee).where("region_type_id=? and fees.code=? and person_type_id=?",params[:region_type_id],params[:fee_code],params[:pt])
    else
      fee_standard=FeeStandard.joins(:fee).where("region_type_id=? and fees.code=? and duty_id=?",params[:region_type_id],params[:fee_code],params[:duty_id])
    end
     #if fee_standard.count==0
     #  fee_standard=FeeStandard.joins(:fee).where("region_type_id=? and fees.code=? and (person_type_id=? or duty_id=?)",params[:region_type_id],params[:fee_code],params[:pt],params[:duty_id])
     #  if fee_standard.count==0
     #    fee_standard=FeeStandard.joins(:fee).where("region_type_id=? and fees.code=? and person_type_id is null and duty_id is null",params[:region_type_id],params[:fee_code])
     #  end
     #end    
    render :json=>fee_standard.count==0 ? "暂时没有".to_json : "#{fee_standard.first.amount},#{fee_standard.first.currency.id},#{fee_standard.first.currency},#{fee_standard.first.currency.default_rate}".to_json
    #"#{fee_standard.first.amount},#{fee_standard.first.currency.id},#{fee_standard.first.currency},#{fee_standard.first.currency.default_rate}"
  end
  def get_extrafee
    hours=(Time.parse(params[:end_time])-Time.parse(params[:start_time]))/3600
    end_time_hour=Time.parse(params[:end_time]).hour
    is_sunday=params[:is_sunday]=="true"
    ex_st= ExtraWorkStandard.joins(:fee).where("is_sunday=? and fees.code=? and larger_than_hours<?",is_sunday,params[:fee_code],hours)
   #if ex_st.count==0
   #  ex_st= ExtraWorkStandard.joins(:fee).where("is_sunday=? and fees.code=? and (late_than_time<=? or larger_than_hours<?)",is_sunday,params[:fee_code],end_time_hour,hours)
   #  if ex_st.count==0
   #    ex_st= ExtraWorkStandard.joins(:fee).where("is_sunday=? and fees.code=? and late_than_time is null and larger_than_hours is null",is_sunday,params[:fee_code])
   #  end
   #end
    render :json=>ex_st.count==0 ? "暂时没有".to_json : ex_st.first.amount
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
