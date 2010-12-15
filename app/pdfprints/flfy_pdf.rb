#coding: utf-8
class FlfyPdf 
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def self.to_pdf(pdf,doc)
    pdf.font "#{RAILS_ROOT}/fonts/arialuni.ttf"
    #title
    pdf.text "福利费用报销单",:size=>18,:align=>:center
    #image
    logo = "public/images/logo_new.png"
    pdf.image logo, :scale => 0.8
    #table here
    pdf.table [
      ["单号",{:text => "#{doc.doc_no}", :colspan => 3, :align => :left}],
      ["申请人","#{doc.person.name}","所属部门","#{doc.person.dep.name}"],
      ["报销日期","#{doc.apply_date}","附件张数","#{doc.attach}"],
      ["是否分摊",{:text => "#{doc.is_split==1 ? "是" : "否"}", :colspan => 3, :align => :left}],
      ["备注",{:text => "#{doc.note}", :colspan => 3, :align => :left}]],
      :width=>pdf.margin_box.width,
      :border_style => :grid,:font_size => 11
    #travel
    if doc.rd_benefits.count>0
      pdf.move_down 10
      pdf.text "福利费用明细",:size=>12
      pdf.move_down 2
      pdf.table doc.rd_benefits.map {|r| ["#{r.dep}","#{r.project}","#{r.fee}","#{r.people_count}","#{r.fee_time_span}","#{r.apply_amount}","#{r.hr_amount}","#{r.fi_amount}"]},
        :headers => ["费用承担部门","项目","费用类型","人数","费用期间","申请费用","HR调整","财务调整"],
        :width=>pdf.margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
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
    pdf.text "报销总金额:  "+"#{doc.total_fi_amount}", :size => 14,:align=>:right
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
    pdf    
  end
end
