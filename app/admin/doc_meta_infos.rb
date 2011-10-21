#coding: utf-8
ActiveAdmin.register DocMetaInfo do
  menu :parent => '系统设置',:label=>'单据信息设置'

  form do |f|
    f.inputs "基本信息" do
      f.input :name
    end
    f.inputs "单据行信息" do
      f.has_many :doc_relations,:label => '单据行信息' do |dr|
        dr.input :doc_row_meta_info
        dr.input :multiple
      end
    end
    f.buttons
  end
  
end
