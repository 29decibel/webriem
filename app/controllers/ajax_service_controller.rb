#coding: utf-8
class AjaxServiceController < ApplicationController
  DocTypeFeeTypeMap={9=>'03',10=>'02',11=>'06',13=>'04'}
  def getbudget
    #get the budget info
    fee_id=Fee.find_by_code(DocTypeFeeTypeMap[params[:doc_type]])
    budget=Budget.dep_of(params[:dep_id].to_i).project_of(params[:project_id].to_i).fee_of(params[:fee_id]).first
    #get the doc
    used=0
    approving_used=0
    this_used=0
    doc=DocHead.find_by_id(params[:doc_id])
    if doc
      this_used=doc.total_fi_amount
    end
    
    docs=DocHead.where("doc_type=#{params[:doc_type]} and afford_dep_id=#{params[:dep_id].to_i} and project_id=#{params[:project_id].to_i}")
    docs.where("doc_state=2 and YEAR(apply_date)=#{params[:year]}").each do |doc|
      used=used+doc.total_fi_amount
    end
    docs.where("doc_state=1 and YEAR(apply_date)=#{params[:year]}").each do |doc|
      approving_used=approving_used+doc.total_fi_amount
    end    
    b_info=BudgetInfo.new 
    if budget
      b_info.fee=budget.fee.name
      b_info.dep=budget.dep.name
      b_info.project=budget.project.name
      b_info.current_year=budget.all
      b_info.used=used
      b_info.approving_used=approving_used
      b_info.this_used=this_used
      b_info.remain=budget.all-used-approving_used-this_used
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
end
