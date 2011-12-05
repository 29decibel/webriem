#coding: utf-8
ActiveAdmin.register WorkFlow do
  menu :label => '审批流设置'
  filter :name
  filter :category
  filter :factors

  index do
    column :id
    column :name
    column :category
    column :doc_meta_infos do |work_flow|
      raw work_flow.doc_meta_infos.map(&:name).join(',')
    end
    column :factors
    column :priority
    column :work_flow_steps do |wf|
      raw wf.work_flow_steps.map(&:name).join(' => ')
    end
    default_actions
  end


  form do |f|
    f.inputs "基本信息" do
      f.input :name
      f.input :doc_meta_infos,:as=>:check_boxes,:wrapper_html=>{:class=>'doc_meta_infos'} 
      f.input :factors,:hint=>'职务:总裁助理,部门:金融能源,姓名:张三（条件之间使用逗号隔开，冒号和逗号都需要为半角字符）'
      f.input :priority,:hint=>'数值越大越会被先应用'
      f.input :category,:as=>:select,:collection => WorkFlow::CATEGORY,:include_blank => false
    end
    f.inputs "审批环节(请确保第一个审批环节为一个人，否则员工无法提交审批)" do
      f.has_many :work_flow_steps,:label=>'添加审批环节' do |p|
        p.input :factors,:hint=>'职务:总裁助理,部门:金融能源,姓名:张三（条件之间使用逗号隔开，冒号和逗号都需要为半角字符）'
        p.input  :step_code
        p.input  :is_self_dep,:hint=>'定位部门顺序：费用承担部门-->所代申请人所在部门-->申请人所在部门'
        p.input  :can_change_approver_steps
        p.input  :max_amount
        p.input  :can_change_amount
        p.input  :_destroy, :as => :boolean, :label => "删除此环节" unless p.object.new_record?
        p.form_buffers.last
      end
    end
    f.buttons
  end

  show do |wf|
    h3 "#{wf.name}【#{wf.category}】"
    h5 "申请人：#{wf.factors}"
    h5("申请单据类型：#{wf.doc_meta_infos.map(&:name).join(',')}") if wf.category=='报销系统'
    div do
      raw wf.work_flow_steps.map(&:name).join(' => ')
    end
  end
end
