#coding: utf-8
ActiveAdmin.register FeeRule do
  menu :label=>'费用预算'
  form do |r|
    r.inputs '预算设置' do
      r.input :fee,:hint=>'预算应用于的费用类型'
      r.input :factors,:hint=>'职务:总裁助理,部门:金融能源,姓名:张三（条件之间使用逗号隔开，冒号和逗号都需要为半角字符）'
      r.input :amount,:hint=>'预算金额'
      r.input :priority,:hint=>'数值越大越会被先应用'
    end
    r.buttons
  end
  
end
