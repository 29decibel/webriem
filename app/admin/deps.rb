#coding: utf-8
ActiveAdmin.register Dep do
  menu :parent => '常用基础档案'
  index do
    column :name
    column :code
    column :status
    column :parent_dep
    default_actions
  end
end
