#coding: utf-8
ActiveAdmin.register DocRowMetaInfo do
  menu :parent => '系统设置',:label => '单据子项设置'
  index do
    column :name
    column :display_name
    column :fee
    default_actions
  end

  show do |dr|
    h3 dr.name
    p dr.all_attributes
  end
  
end
