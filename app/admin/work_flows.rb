#coding: utf-8
ActiveAdmin.register WorkFlow do
  menu :label => '审批流设置'
  filter :name

  index do
    column :name
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
    end
    f.inputs "审批环节" do
      f.has_many :work_flow_steps,:label=>'添加审批环节' do |p|
        p.input  :is_self_dep,:wrapper_html=>{:class=>'is_self_dep'}
        p.input  :dep,:wrapper_html=>{:class=>'dep'}
        p.input  :duty
        p.input  :max_amount
        # p.input  :_destroy, :as => :boolean, :label => "Delete this picture" unless p.object.new_record?
      end
    end
    f.buttons
  end

  show do |wf|
    h3 wf.name
    div do
      raw wf.work_flow_steps.map(&:name).join(' => ')
    end
  end
end
