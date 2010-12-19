#coding: utf-8
class AjaxServiceController < ApplicationController
  def getbudget
    #get the budget info
    budget=Budget.dep_of(params[:dep_id].to_i).project_of(params[:project_id].to_i).fee_of(params[:fee_id]).first
    #get the doc
    doc=DocHead.find(params[:doc_id])
    used=0
    approving_used=0
    docs=DocHead.where("doc_type=#{doc.doc_type} and afford_dep_id=#{doc.afford_dep_id} and project_id=#{doc.project_id}")
    docs.where("doc_state=2").each do |doc|
      used=used+doc.total_fi_amount
    end
    docs.where("doc_state=1").each do |doc|
      approving_used=approving_used+doc.total_fi_amount
    end
    b_info=BudgetInfo.new 
    if budget
      b_info.fee=budget.fee.name
      b_info.dep=budget.dep.name
      b_info.project=budget.project.name
      b_info.current_month=budget.by_month(params[:month])
      b_info.used=used
      b_info.approving_used=approving_used
      b_info.this_used=0
      b_info.remain=0
    end
    render :xml=>b_info.to_xml
  end
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
