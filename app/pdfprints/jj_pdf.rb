#coding: utf-8
class JjPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def self.get_pdf
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
      ["借款日期","#{doc.apply_date}","附件张数","#{doc.attach}"],
      ["借款用途",{:text => "#{doc.note}",:colspan => 3, :align => :left}]],
      :width=>margin_box.width,
      :border_style => :grid,:font_size => 11
    #travel
    if doc.rd_work_meals.count>0
      move_down 10
      text "交际费明细",:size=>12
      move_down 2
      table doc.rd_work_meals.map {|r| ["#{r.dep.name}","#{r.project.name}","#{r.place}","#{r.apply_date}","#{r.aa}","#{r.ori_amount}","#{r.rate}","#{r.apply_amount}","#{r.hr_amount}","#{r.fi_amount}"]},
        :headers => ["费用承担部门","项目","地点","日期","人数","事由","币种","汇率","原币金额","本币金额"],
        :width=>margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
    end
    #transport
    if doc.rd_transports.count>0
      move_down 10
      text "交通费明细",:size=>12
      move_down 2
      table doc.rd_transports.map {|r| ["#{r.start_date}","#{r.end_date}","#{r.start_position}","#{r.end_position}","#{r.ori_amount}","#{r.rate}","#{r.apply_amount}","#{r.hr_amount}","#{r.fi_amount}"]},
        :headers => ["开始时间","到达时间","出发地","目的地","原币金额","汇率","本币金额","HR调整","财务调整"],
        :width=>margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
    end
    #lodging
    if doc.rd_lodgings.count>0
      move_down 10
      text "住宿费明细",:size=>12
      move_down 2
      table doc.rd_lodgings.map {|r| ["#{r.start_date}","#{r.end_date}","#{r.days}","#{r.region}","#{r.people_count}","#{r.ori_amount}","#{r.rate}","#{r.apply_amount}","#{r.hr_amount}","#{r.fi_amount}"]},
        :headers => ["开始日期","结束日期","住宿天数","城市","人数","原币金额","汇率","本币金额","HR调整","财务调整"],
        :width=>margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
    end
    #other riems
    if doc.other_riems.count>0
      move_down 10
      text "其他费用明细",:size=>12
      move_down 2
      table doc.other_riems.map {|r| ["#{r.sequence}","#{r.description}","#{r.ori_amount}","#{r.rate}","#{r.apply_amount}","#{r.hr_amount}","#{r.fi_amount}"]},
        :headers => ["序号","费用说明","原币金额","汇率","本币金额","HR调整","财务调整"],
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
      table doc.recivers.map {|r| ["#{r.settlement}","#{r.company}","#{r.bank}","#{r.bank_no}","#{r.amount}","#{r.hr_amount}","#{r.fi_amount}"]},
        :headers => ["结算方式","收款人","银行","银行帐号","本币金额","HR调整","财务调整"],
        :width=>margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
    end
    self.render
  end
end