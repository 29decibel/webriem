#coding: utf-8
ActiveAdmin.register FeeStandard do
  menu :parent => '常用基础档案',:label=>'费用标准'

  index do
    column :duty,:sortable=>false
    column :region_type,:sortable=>false
    column :person_type,:sortable=>false
    column :currency,:sortable=>false
    column :amount
    default_actions
  end
end
