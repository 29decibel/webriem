#coding: utf-8
class GdzcPdf 
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def self.to_pdf(pdf,doc)
    pdf.font "#{Rails.root}/fonts/arialuni.ttf"
    #title
    pdf.text "固定资产入账单",:size=>18,:align=>:center
    #image
    logo = "public/images/logo_new.png"
    pdf.image logo, :scale => 0.8
    #table here
    pdf.table [
      ["单号",{:text => "#{doc.doc_no}", :colspan => 3, :align => :left}],
      ["申请人","#{doc.person.name}","所属部门","#{doc.person.dep.name}"],
      ["申请日期",{:text => "#{doc.apply_date}",:colspan => 3, :align => :left}],
      ["备注",{:text => "#{doc.note}",:colspan => 3, :align => :left}]],
      :column_widths=>{0=>80,1=>190,2=>80,3=>190},
      :width=>pdf.margin_box.width,
      :border_style => :grid,:font_size => 11
    #travel
    if doc.fixed_properties.count>0
      pdf.move_down 10
      pdf.text "固定资产入账明细",:size=>12
      pdf.move_down 2
      pdf.table doc.fixed_properties.map {|r| ["#{r.property_type.name}","#{r.name}","#{r.code}","#{r.sequence}","#{r.buy_unit}","#{r.buy_count}","#{r.original_value}","#{r.keeper.name}","#{r.place}","#{r.afford_dep.name}","#{r.project.name}"]},
        :headers => ["资产类型","资产名称","规格型号","序列号","购入单价","购入数量","原值","保管人","存放地点","承担部门","承担项目"],
	:column_widths=>{0=>60,1=>60,2=>60,3=>40,4=>70,5=>30,6=>60,7=>60,8=>40,9=>30,10=>30},
        :width=>pdf.margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
    end

    #final render
    pdf.move_down 5
    pdf.text "申请总金额:  "+"#{doc.total_amount}", :size => 14,:align=>:right
    #work flow infos
    if doc.work_flow_infos.count>0
      pdf.move_down 10
      pdf.text "审批信息",:size=>12
      pdf.move_down 2
      pdf.table doc.work_flow_infos.map {|w| ["#{w.approver}","#{w.created_at}","#{w.is_ok==1 ? "通过" : "否决"}","#{w.comments}"]},
        :headers => ["审批人","审批时间","是否通过","批语"],
        :width=>pdf.margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"] 
    end
    pdf    
  end
end
