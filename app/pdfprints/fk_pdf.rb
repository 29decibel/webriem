#coding: utf-8
class FkPdf 
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def self.to_pdf(pdf,doc)
     #font_families.update(
     #     "MyFontFamily" => {:bold        => "#{RAILS_ROOT}/fonts/arialuni.ttf",
     #                        :italic      => "#{RAILS_ROOT}/fonts/arialuni.ttf",
     #                        :bold_italic => "#{RAILS_ROOT}/fonts/arialuni.ttf",
     #                        :normal      => "#{RAILS_ROOT}/fonts/arialuni.ttf" })
    #font("MyFontFamily")
    pdf.font "#{RAILS_ROOT}/fonts/arialuni.ttf"
    #title
    pdf.text "付款单",:size=>18,:align=>:center
    #image
    logo = "public/images/logo_new.png"
    pdf.image logo, :scale => 0.8
    #the note table
    #todo
    #table here
    pdf.table [
      ["单号",{:text => "#{doc.doc_no}", :colspan => 3, :align => :left}],
      ["申请人","#{doc.person.name}","所属部门","#{doc.person.dep.name}"],
      ["付款日期","#{doc.apply_date}","附件张数","#{doc.attach}"],
      ["付款原因",{:text => "#{doc.note}",:colspan => 3, :align => :left}]],
      :width=>pdf.margin_box.width,
      :column_widths=>{0=>80,1=>190,2=>80,3=>190},
      :border_style => :grid,:font_size => 11
    #travel
    if doc.cp_doc_details.count>0
      pdf.move_down 10
      pdf.text "付款单据明细",:size=>12
      pdf.move_down 2
      pdf.table doc.cp_doc_details.map {|r| ["#{r.dep.name}","#{r.project ? r.project.name : ''}","#{r.used_for}","#{r.currency.name}","#{r.rate}","#{r.ori_amount}","#{r.apply_amount}"]},
        :headers => ["费用承担部门","项目","费用用途","币种","汇率","原币金额","本币金额"],
        :width=>pdf.margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :column_widths=>{0=>85,1=>100,2=>140,3=>40,4=>35,5=>70,6=>70},
        :row_colors => ["FFFFFF", "DDDDDD"]
    end
    #slipt
    if doc.is_split==1 and doc.reim_split_details.count>0
        pdf.move_down 10
        pdf.text "费用分摊明细",:size=>12
        pdf.move_down 2
        pdf.table doc.reim_split_details.map {|r| ["#{r.sequence}","#{r.dep}","#{r.project}","#{r.percent}","#{r.percent_amount}"]},
          :headers => ["序号","费用承担部门","项目","百分比","分摊金额"],
          :width=>pdf.margin_box.width,
          :border_style => :grid,
          :header=>true,:font_size => 10,
          :row_colors => ["FFFFFF", "DDDDDD"]
    end
    #final render
    pdf.move_down 5
    pdf.text "付款总金额:  "+"#{doc.total_fi_amount}", :size => 14,:align=>:right
    #work flow infos
    if doc.work_flow_infos.count>0
      pdf.move_down 10
      pdf.text "审批信息",:size=>12
      pdf.move_down 2
      pdf.table doc.work_flow_infos.map {|w| ["#{w.person}","#{w.created_at}","#{w.is_ok==1 ? "通过" : "否决"}","#{w.comments}"]},
        :headers => ["审批人","审批时间","是否通过","批语"],
        :width=>pdf.margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"] 
    end
    #recivers info 
    if doc.recivers.count>0
      pdf.move_down 10
      pdf.text "收款单位明细",:size=>12
      pdf.move_down 2
      pdf.table doc.recivers.map {|r| ["#{r.settlement}","#{r.company}","#{r.bank}","#{r.bank_no}","#{r.amount}"]},
        :headers => ["结算方式","收款单位","银行","银行帐号","金额"],
        :width=>pdf.margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
    end
    pdf    
  end
end