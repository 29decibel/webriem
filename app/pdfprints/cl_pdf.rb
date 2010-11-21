#coding: utf-8
class ClPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def to_pdf
    font "#{::Prawn::BASEDIR}/data/fonts/STSONG.ttf"
    #title
    text "差旅费报销单",:size=>18,:align=>:center
    #image
    logo = "public/images/logo_new.png"
    image logo, :scale => 0.8
    #table here
    table [
      ["单号",{:text => "#{doc.doc_no}", :colspan => 3, :align => :left}],
      ["出差人","#{doc.person.name}","所属部门","#{doc.person.dep.name}"],
      ["报销日期","#{doc.apply_date}","附件张数","#{doc.attach}"],
      ["项目编号","#{doc.project ? doc.project.code : ""}","项目名称","#{doc.project ? doc.project.name : ""}"],
      ["费用承担部门",{:text => "#{doc.dep ? doc.dep.name : ""}", :colspan => 3, :align => :left}]],
      :width=>margin_box.width,
      :border_style => :grid,:font_size => 11
    #travel
    if doc.rd_travels.count>0
      move_down 10
      text "差旅费补助明细",:size=>12
      move_down 2
      table doc.rd_travels.map {|r| ["#{r.days}","#{r.region_type.name}","#{r.region}","#{r.reason}","#{r.ori_amount}","#{r.rate}","#{r.apply_amount}","#{r.hr_amount}","#{r.fi_amount}"]},
        :headers => ["出差天数","地区级次","出差地点","出差事由","原币金额","汇率","本币金额","HR调整","财务调整"],
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
    if doc.riem_cp_offsets.count>0
      move_down 10
      text "借款单冲抵明细",:size=>12
      move_down 2
      table doc.riem_cp_offsets.map {|r| ["#{r.cp_doc_head.doc_no}","#{r.cp_doc_head.apply_date}","#{r.cp_doc_head.project}","#{r.cp_doc_head.total_apply_amount}","#{r.amount}"]},
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