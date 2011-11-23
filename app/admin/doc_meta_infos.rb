#coding: utf-8
ActiveAdmin.register DocMetaInfo do
  menu :parent => '系统设置',:label=>'单据信息设置'

  form do |f|
    f.inputs "基本信息" do
      f.input :name
      f.input :code
      f.input :display_name
      f.input :doc_head_attrs,:as=>:check_boxes,:collection => DocHead.column_names.map{|n|[n,n]}
    end
    f.inputs "单据行信息" do
      f.has_many :doc_relations,:label => '单据行信息' do |dr|
        dr.input :doc_row_meta_info
        dr.input :multiple
        dr.input :doc_row_attrs
        dr.input  :_destroy, :as => :boolean, :label => "删除此环节" unless dr.object.new_record?
        dr.form_buffers.last
      end
    end
    f.buttons
  end
  
end
