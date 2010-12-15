#coding: utf-8
class JjPdf 
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def self.to_pdf(pdf,doc)
    pdf.font "#{RAILS_ROOT}/fonts/arialuni.ttf"
    #title
    pdf.text "交际费用报销",:size=>18,:align=>:center
    #image
    logo = "public/images/logo_new.png"
    pdf.image logo, :scale => 0.8
    #table here
    pdf.table [
      ["单号",{:text => "#{doc.doc_no}", :colspan => 3, :align => :left}],
      ["申请人","#{doc.person.name}","所属部门","#{doc.person.dep.name}"],
      ["申请日期","#{doc.apply_date}","附件张数","#{doc.attach}"],
      ["备注",{:text => "#{doc.note}",:colspan => 3, :align => :left}]],
      :width=>pdf.margin_box.width,
      :border_style => :grid,:font_size => 11
    #travel
    if doc.rd_work_meals.count>0
      pdf.move_down 10
      pdf.text "交际费明细",:size=>12
      pdf.move_down 2
      pdf.table doc.rd_work_meals.map {|r| ["#{r.dep ? r.dep.name : ""}","#{r.project ? r.project.name : ""}","#{r.place}","#{r.meal_date}","#{r.people_count}","#{r.person_names}","#{r.currency.name}","#{r.rate}","#{r.ori_amount}","#{r.apply_amount}"]},
        :headers => ["费用承担部门","项目","地点","日期","人数","参与人","币种","汇率","原币金额","本币金额"],
        :width=>pdf.margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
    end
    #冲地
    if doc.reim_cp_offsets.where("amount>0").count>0
      pdf.move_down 10
      pdf.text "借款单冲抵明细",:size=>12
      pdf.move_down 2
      pdf.table doc.reim_cp_offsets.where("amount>0").map {|r| ["#{r.cp_doc_head.doc_no}","#{r.cp_doc_head.apply_date}","#{r.cp_doc_head.project}","#{r.cp_doc_head.total_apply_amount}","#{r.amount}"]},
        :headers => ["单号","申请时间","项目","申请总金额","冲抵金额"],
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
    #recivers info 
    if doc.recivers.count>0
      pdf.move_down 10
      pdf.text "收款人信息",:size=>12
      pdf.move_down 2
      pdf.table doc.recivers.map {|r| ["#{r.settlement}","#{r.company}","#{r.bank}","#{r.bank_no}","#{r.amount}"]},
        :headers => ["结算方式","收款人","银行","银行帐号","本币金额"],
        :width=>pdf.margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
    end
    pdf    
  end
end
