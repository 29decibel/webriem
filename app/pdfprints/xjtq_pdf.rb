#coding: utf-8
class XjtqPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def to_pdf
    font "#{RAILS_ROOT}/fonts/STSONG.ttf"
    #title
    text "现金提取",:size=>18,:align=>:center
    #image
    logo = "public/images/logo_new.png"
    image logo, :scale => 0.8
    #table here
    table [
      ["单号",{:text => "#{doc.doc_no}", :colspan => 3, :align => :left}],
      ["申请人","#{doc.person.name}","所属部门","#{doc.person.dep.name}"],
      ["申请日期","#{doc.apply_date}","附件张数","#{doc.attach}"],
      ["备注",{:text => "#{doc.note}", :colspan => 3, :align => :left}]],
      :width=>margin_box.width,
      :border_style => :grid,:font_size => 11
    #现金提取详细
    if doc.inner_cash_draw
      move_down 10
      text "现金提取申请详细",:size=>12
      move_down 2
      table [
        ["提现账户",{:text => "#{doc.inner_cash_draw.account}", :colspan => 3, :align => :left}],
        ["提现前余额",{:text => "#{doc.inner_cash_draw.now_remain_amout}", :colspan => 3, :align => :left}]],
        :width=>margin_box.width,
        :border_style => :grid,:font_size => 11
      #现金提取详细
      if doc.inner_cash_draw.cash_draw_items.count>0
        move_down 10
        text "现金提取明细",:size=>12
        move_down 2
        table doc.inner_cash_draw.cash_draw_items.map {|r| ["#{r.sequence}","#{r.used_for}","#{r.apply_amount}"]},
          :headers => ["序号","用途","申请金额"],
          :width=>margin_box.width,
          :border_style => :grid,
          :header=>true,:font_size => 10,
          :row_colors => ["FFFFFF", "DDDDDD"]
      end
    end
    #final render
    move_down 5
    text "现金提取总金额:  "+"#{number_to_currency(doc.total_apply_amount, :unit => '￥')}", :size => 14,:align=>:right
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
    self.render
  end
end
