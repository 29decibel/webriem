#coding: utf-8
class NormalDoc

  def self.human_name(obj,col_name)
    col = obj.class.columns.select{|c|c.name==col_name}.first
    ass = obj.class.reflect_on_all_associations(:belongs_to).select{|ass|ass.foreign_key==col_name}.first
    if ass
      obj.send(ass.name).try(:name) || ''
    else
      obj.send(col_name).try(:to_s) || ''
    end
  end

  def self.single_table(pdf,obj,print_attrs)
    return if obj.blank?
    head_data = print_attrs.in_groups_of(2).map{|g| [
      I18n.t("activerecord.attributes.#{obj.class.name.underscore}.#{g[0]}"),
      human_name(obj,g[0]),
      g[1] ? I18n.t("activerecord.attributes.#{obj.class.name.underscore}.#{g[1]}") : '',
      g[1] ? human_name(obj,g[1]) : ''
    ]}
    return if head_data.blank?
    Rails.logger.info 'get the loged data here......'
    Rails.logger.info head_data
    # draw table
    pdf.table head_data,:column_widths=>{0=>80,1=>190,2=>80,3=>190},
      :width=>pdf.margin_box.width,:border_style => :grid,:font_size => 11
  end

  def self.index_table(pdf,class_name,rows,print_attrs)
    return if print_attrs.count==0
    header_info = print_attrs.map{|pa| I18n.t("activerecord.attributes.#{class_name.underscore}.#{pa}")}
    # calculate cols
    left_width = 540 % print_attrs.count
    col_width = 540 / print_attrs.count
    col_width_hash = {}
    print_attrs.count.times {|i| col_width_hash[i] = col_width}
    col_width_hash[print_attrs.count-1] += left_width 
    # get another data
    table_data = rows.map {|r| print_attrs.map{|pa| human_name(r,pa)} }
    Rails.logger.info '##############################'
    Rails.logger.info rows
    Rails.logger.info table_data
    Rails.logger.info '##############################'
    pdf.table table_data,:headers => header_info,
        :column_widths=>col_width_hash,
        :width=>pdf.margin_box.width,
        :border_style => :grid,
        :header=>true,:font_size => 10,
        :row_colors => ["FFFFFF", "DDDDDD"]
  end

  def self.header(pdf,name)
    pdf.move_down 10
    pdf.text name,:size=>12
    pdf.move_down 5
  end

  def self.to_pdf(pdf,doc)
    doc_meta = doc.doc_meta_info
    pdf.font "#{Rails.root}/app/assets/fonts/arialuni.ttf"
    #title
    pdf.text doc_meta.display_name,:size=>18,:align=>:center
    #image
    logo = "#{Rails.root}/app/assets/images/vrv_logo.jpg"
    pdf.image logo, :scale => 0.4,:at=>[0,730]
    pdf.move_down 10
    #print doc head
    if doc_meta.print_attrs.count>0
      single_table(pdf,doc,doc_meta.print_attrs)
    end
    # draw one-one relation, same with above
    doc_meta.doc_relations.each do |dr|
      next if dr.print_attrs.count==0
      if !dr.multiple
        data = doc.send(dr.doc_row_meta_info.name.underscore)
        Rails.logger.info data
        if !data.blank? 
          header(pdf,dr.doc_row_meta_info.display_name)
          single_table(pdf,data,dr.print_attrs)
        end
      else
        rows = doc.send(eval(dr.doc_row_meta_info.name).table_name)
        if rows.count>0
          header(pdf,dr.doc_row_meta_info.display_name)
          index_table(pdf,dr.doc_row_meta_info.name,rows,dr.print_attrs)
        end
      end
    end
    #final render
    pdf.move_down 10
    pdf.text "报销总金额:  "+"￥#{doc.total_amount}", :size => 14,:align=>:right
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

    pdf.move_down 10
    pdf.text "本打印文档属于#{SystemConfig.value('company')||'OES'}内部资料",:size=>8

    pdf
  end
end

