#coding: utf-8
ActiveAdmin.register Role do
  menu :parent => '常用基础档案',:label=>'角色'
  filter :name
  form do |f|
    f.inputs "基本信息" do
      f.input :name
      f.input :menus,:as=>:check_boxes
    end
    f.buttons
  end
end
