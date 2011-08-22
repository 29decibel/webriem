#coding: utf-8
ActiveAdmin.register Person do
  menu :parent => '常用基础档案'

  index do
    column :id
    column :name
    column :code
    column :dep,:sortable=>false
    column :duty,:sortable=>false
    column :e_mail
    default_actions
  end
end
