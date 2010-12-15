#coding: utf-8
class ShlcPdf 
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def self.to_pdf(pdf,doc)
    pdf.font "#{RAILS_ROOT}/fonts/arialuni.ttf"
    #title
    pdf.text "赎回理财产品",:size=>18,:align=>:center
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
    #赎回理财产品详细
    if doc.redeem_finance_product
      pdf.move_down 10
      pdf.text "赎回理财产品详细",:size=>12
      pdf.move_down 2
      pdf.table [
        ["理财产品名称",{:text => "#{doc.redeem_finance_product.name}", :colspan => 3, :align => :left}],
        ["赎回账户",{:text => "#{doc.redeem_finance_product.account}", :colspan => 3, :align => :left}],
        ["申请赎回金额","#{doc.redeem_finance_product.amount}","理财产品利率","#{doc.redeem_finance_product.rate}"],
        ["申请赎回日期","#{doc.redeem_finance_product.clear_date}","预计赎回日期","#{doc.redeem_finance_product.redeem_date}"],
        ["申请赎回原因",{:text => "#{doc.redeem_finance_product.description}", :colspan => 3, :align => :left}]],
        :width=>pdf.margin_box.width,
        :border_style => :grid,:font_size => 11
    end
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