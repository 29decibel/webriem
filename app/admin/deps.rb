#coding: utf-8
ActiveAdmin.register Dep do
  menu :parent => '常用基础档案',:label=>'部门'
  index do
    column :name
    column :code
    column :status
    column :parent_dep
    column :org
    default_actions
  end
end
