#coding: utf-8
class JjPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def to_pdf
    font "#{::Prawn::BASEDIR}/data/fonts/STSONG.ttf"
    #title
    text "交际费用报销",:size=>18,:align=>:center
    #image
    logo = "public/images/logo_new.png"
    image logo, :scale => 0.8
    #table here
    table [
      ["单号",{:text => "#{doc.doc_no}", :colspan => 3, :align => :left}],
      ["申请人","#{doc.person.name}","所属部门","#{doc.person.dep.name}"],
      ["申请日期","#{doc.apply_date}","附件张数","#{doc.attach}"],
      ["备注",{:text => "#{doc.note}",:colspan => 3, :align => :left}]],
      :width=>margin_box.width,
      :border_style => :grid,:font_size => 11
    #travel
    if doc.rd_work_meals.count>0
      move_down 10
      text "交际费明细",:size=>12
      move_down 2
      table doc.rd_work_meals.map {|r| ["#{r.dep ? r.dep.name : ""}","#{r.project ? r.project.name : ""}","#{r.place}","#{r.meal_date}","#{r.people_count}","#{r.currency.name}","#{r.rate}","#{r.ori_amount}","#{r.apply_amount}"]},
        :headers => ["费用承担部门","项目","地点","日期","人数","币种","汇率","原币金额","本币金额"],
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
      table doc.recivers.map {|r| ["#{r.settlement}","#{r.company}","#{r.bank}","#{r.bank_no}","#{r.amount}"]},
        :headers => ["结算方式","收款人","银行","银行帐号","本币金额"],
        :width=>margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
    end
    self.render
  end
end