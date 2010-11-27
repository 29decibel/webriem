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
    render :json=>fee_standard.count==0 ? "#{I18n.t('controller_msg.none')}".to_json : "#{fee_standard.first.amount},#{fee_standard.first.currency.id},#{fee_standard.first.currency},#{fee_standard.first.currency.default_rate}".to_json
    #"#{fee_standard.first.amount},#{fee_standard.first.currency.id},#{fee_standard.first.currency},#{fee_standard.first.currency.default_rate}"
  end
  def get_extrafee
    #now i only care about the end time
    end_time=Time.parse(params[:end_time])
    puts params[:end_time]
    puts end_time
    #hours=(Time.parse(params[:end_time])-Time.parse(params[:start_time]))/3600
    #end_time_hour=Time.parse(params[:end_time]).hour
    is_sunday=params[:is_sunday]=="true"
    if is_sunday
      ex_st= ExtraWorkStandard.joins(:fee).where("is_sunday=? and fees.code=? ",is_sunday,params[:fee_code])
    else
      ex_st= ExtraWorkStandard.joins(:fee).where("is_sunday=? and fees.code=? and timediff(time(?),time(late_than_time))>=0",is_sunday,params[:fee_code],end_time.to_s)
    end
    render :json=>ex_st.count==0 ? "#{I18n.t('controller_msg.none')}".to_json : ex_st.first.amount
  end
  def remove_offset
    @doc_head=DocHead.find(params[:reim_doc_head_id].to_i)
    #add back the amount
    rp_doc=DocHead.find(params[:cp_doc_head_id].to_i)
    rp_offset=RiemCpOffset.where("cp_doc_head_id = ? and reim_doc_head_id= ? ",params[:cp_doc_head_id].to_i,params[:reim_doc_head_id].to_i).first
    rp_doc.update_attribute(:cp_doc_remain_amount,rp_doc.cp_doc_remain_amount+rp_offset.amount)
    rp_offset.destroy
    @message="#{I18n.t('controller_msg.remove_ok')}"
    render "shared/show_result"
  end
  #==================================output to txt========================================
  def output_to_txt
    send_data Person.first, :filename => "hello.txt",:type => "application/txt"
  end
end
