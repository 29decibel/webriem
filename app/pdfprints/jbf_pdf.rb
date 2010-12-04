#coding: utf-8
class JbfPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def to_pdf
    font "#{RAILS_ROOT}/fonts/arialuni.ttf"
    #title
    text "加班费用报销单",:size=>18,:align=>:center
    #image
    logo = "public/images/logo_new.png"
    image logo, :scale => 0.8
    #table here
    table [
      ["单号",{:text => "#{doc.doc_no}", :colspan => 3, :align => :left}],
      ["申请人","#{doc.person.name}","所属部门","#{doc.person.dep.name}"],
      ["报销日期","#{doc.apply_date}","附件张数","#{doc.attach}"],
      ["项目编号","#{doc.project ? doc.project.code : ""}","项目名称","#{doc.project ? doc.project.name : ""}"],
      ["费用承担部门","#{doc.dep ? doc.dep.name : ""}","是否分摊","#{doc.is_split==1 ? "是" : "否"}"]],
      :width=>margin_box.width,
      :border_style => :grid,:font_size => 11
    #travel
    if doc.rd_extra_work_meals.count>0
      move_down 10
      text "加班餐费明细",:size=>12
      move_down 2
      table doc.rd_extra_work_meals.map {|r| ["#{r.is_sunday==0 ? "是" : "否" }","#{r.start_time}","#{r.end_time}","#{r.currency.name}","#{r.ori_amount}","#{r.rate}","#{r.apply_amount}","#{r.hr_amount}","#{r.fi_amount}"]},
        :headers => ["休息日","开始时间","结束时间","币种","原币金额","汇率","本币金额","HR调整","财务调整"],
        :width=>margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
    end
    #rd_extra_work_cars
    if doc.rd_extra_work_cars.count>0
      move_down 10
      text "加班车费明细",:size=>12
      move_down 2
      table doc.rd_extra_work_cars.map {|r| ["#{r.is_sunday==0 ? "是" : "否" }","#{r.start_place}","#{r.end_place}","#{r.start_time}","#{r.end_time}","#{r.currency.name}","#{r.ori_amount}","#{r.rate}","#{r.apply_amount}","#{r.hr_amount}","#{r.fi_amount}"]},
        :headers => ["休息日","开始地点","结束地点","开始时间","结束时间","币种","原币金额","汇率","本币金额","HR调整","财务调整"],
        :width=>margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
    end
    #冲地
    if doc.reim_cp_offsets.where("amount>0").count>0
      move_down 10
      text "借款单冲抵明细",:size=>12
      move_down 2
      table doc.reim_cp_offsets.where("amount>0").map {|r| ["#{r.cp_doc_head.doc_no}","#{r.cp_doc_head.apply_date}","#{r.cp_doc_head.project}","#{r.cp_doc_head.total_apply_amount}","#{r.amount}"]},
        :headers => ["单号","申请时间","项目","申请总金额","冲抵金额"],
        :width=>margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
    end
    #slipt
    if doc.is_split==1 and doc.reim_split_details.count>0
        move_down 10
        text "费用分摊明细",:size=>12
        move_down 2
        table doc.reim_split_details.map {|r| ["#{r.sequence}","#{r.dep}","#{r.project}","#{r.percent}","#{r.percent_amount}"]},
          :headers => ["序号","费用承担部门","项目","百分比","分摊金额"],
          :width=>margin_box.width,
          :border_style => :grid,
          :header=>true,:font_size => 10,
          :row_colors => ["FFFFFF", "DDDDDD"]
    end
    #final render
    move_down 5
    text "报销总金额:  "+"#{number_to_currency(doc.total_apply_amount, :unit => '￥')}", :size => 14,:align=>:right
    #work flow infos
    if doc.work_flow_infos.count>0
      move_down 10
      text "审批信息",:size=>12
      move_down 2
      table doc.work_flow_infos.map {|w| ["#{w.person}","#{w.created_at}","#{w.is_ok==1 ? "通过" : "否决"}","#{w.comments}"]},
        :headers => ["审批人","审批时间","是否通过","批语"],
        :width=>margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"] 
    end
    #recivers info 
    if doc.recivers.count>0
      move_down 10
      text "收款人信息",:size=>12
      move_down 2
      data_array=doc.recivers.map {|r| ["#{r.settlement}","#{r.company}","#{r.bank}","#{r.bank_no}","#{r.amount}","#{r.hr_amount}","#{r.fi_amount}"]}
      data_array<<["收款人签名",{:text => "", :colspan => 6, :align => :left}]
      table data_array,
        :headers => ["结算方式","收款人","银行","银行帐号","本币金额","HR调整","财务调整"],
        :width=>margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
      
    end
    self.render
  end
end
