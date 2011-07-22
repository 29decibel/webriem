#coding: utf-8
class JhPdf 
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def self.to_pdf(pdf,doc)
    pdf.font "#{Rails.root}/fonts/arialuni.ttf"
    #title
    pdf.text "结汇单",:size=>18,:align=>:center
    #image
    logo = "public/images/logo_new.png"
    pdf.image logo, :scale => 0.8
    #table here
    pdf.table [
      ["单号",{:text => "#{doc.doc_no}", :colspan => 3, :align => :left}],
      ["申请人","#{doc.person.name}","所属部门","#{doc.person.dep.name}"],
      ["申请日期","#{doc.apply_date}","附件张数","#{doc.attach}"],
      ["备注",{:text => "#{doc.note}", :colspan => 3, :align => :left}]],
      :column_widths=>{0=>80,1=>190,2=>80,3=>190},
      :width=>pdf.margin_box.width,
      :border_style => :grid,:font_size => 11
    #结汇申请详细
    if doc.inner_remittance
      pdf.move_down 10
      pdf.text "结汇申请详细",:size=>12
      pdf.move_down 2
      pdf.table [
        ["申请金额","#{doc.inner_remittance.amount}","币种","#{doc.inner_remittance.currency.try(:name)}"],
        ["结汇账户","#{doc.inner_remittance.out_account}","结汇账户结汇后余额","#{doc.inner_remittance.remain_amount}$"],
        ["收款账户","#{doc.inner_remittance.in_account}","收款账户结汇后余额","#{doc.inner_remittance.in_amount_after}￥"],
        ["当日汇率",{:text => "#{doc.inner_remittance.now_rate_price}", :colspan => 3, :align => :left}],
        ["申请原因",{:text => "#{doc.inner_remittance.description}", :colspan => 3, :align => :left}]],
        :width=>pdf.margin_box.width,
        :border_style => :grid,:font_size => 11
    end
    #work flow infos
    if doc.work_flow_infos.count>0
      pdf.move_down 10
      pdf.text "审批信息",:size=>12
      pdf.move_down 2
      pdf.table doc.work_flow_infos.map {|w| ["#{w.approver}","#{w.created_at}","#{w.is_ok==1 ? "通过" : "否决"}","#{w.comments}"]},
        :headers => ["审批人","审批时间","是否通过","批语"],
        :width=>pdf.margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"] 
    end
    pdf    
  end
end
