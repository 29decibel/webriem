#coding: utf-8
ActiveAdmin.register WorkFlow do
  menu :label => '审批流设置'
  filter :name
  filter :category

  index do
    column :name
    column :category
    column :doc_meta_infos do |work_flow|
      raw work_flow.doc_meta_infos.map(&:name).join(',')
    end
    column :duties do |work_flow|
      raw work_flow.duties.map(&:name).join(',')
    end
    column :work_flow_steps do |wf|
      raw wf.work_flow_steps.map(&:name).join(' => ')
    end
    default_actions
  end


  form do |f|
    f.inputs "基本信息" do
      f.input :name
      f.input :doc_meta_infos,:as=>:check_boxes,:wrapper_html=>{:class=>'doc_meta_infos'} 
      f.input :duties,:as=>:check_boxes
      f.input :category,:as=>:select,:collection => WorkFlow::CATEGORY,:include_blank => false
    end
    f.inputs "审批环节" do
      f.has_many :work_flow_steps,:label=>'添加审批环节' do |p|
        p.input  :step_code
        p.input  :is_self_dep,:wrapper_html=>{:class=>'is_self_dep'}
        p.input  :dep,:wrapper_html=>{:class=>'dep'}
        p.input  :duty
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
    h5 "申请人职务：#{wf.duties.map(&:name).join(',')}"
    h5("申请单据类型：#{wf.doc_meta_infos.map(&:name).join(',')}") if wf.category=='报销系统'
    div do
      raw wf.work_flow_steps.map(&:name).join(' => ')
    end
  end
end
