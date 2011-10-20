#coding: utf-8
ActiveAdmin.register Project do
  menu :parent => '常用基础档案',:label=>'项目'

  index do
    column :name
    column :code
    column :status,:sortable=>:status do |p|
      p.status == '0' ? "打开" : "关闭"
    end
    default_actions
  end
end
