#coding: utf-8
ActiveAdmin.register Fee do
  menu :parent => '常用基础档案',:label=>'费用类型'
  filter :name
  filter :code
  index do
    column :name
    column :code
    column :fee_type
    default_actions
  end
end
