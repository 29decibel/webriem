#coding: utf-8
class GmlcPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def to_pdf
    font "#{RAILS_ROOT}/fonts/STSONG.TTF"
    #title
    text "购买理财产品",:size=>18,:align=>:center
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
    #购买理财产品详细
    if doc.buy_finance_product
      move_down 10
      text "购买理财产品详细",:size=>12
      move_down 2
      table [
        ["理财产品名称",{:text => "#{doc.buy_finance_product.name}", :colspan => 3, :align => :left}],
        ["购买账户",{:text => "#{doc.buy_finance_product.account}", :colspan => 3, :align => :left}],
        ["申请购买金额","#{doc.buy_finance_product.amount}","理财产品利率","#{doc.buy_finance_product.rate}"],
        ["预计购买日期","#{doc.buy_finance_product.buy_date}","预计赎回日期","#{doc.buy_finance_product.redeem_date}"],
        ["申请购买原因及预期收益",{:text => "#{doc.buy_finance_product.description}", :colspan => 3, :align => :left}]],
        :width=>margin_box.width,
        :border_style => :grid,:font_size => 11
    end
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