#coding: utf-8
ActiveAdmin.register WorkFlow do
  form do |f|
    f.inputs "基本信息" do
      f.input :name
      f.inputs :doc_meta_infos,:as=>:check_boxes , :collection => ['aa','bb']
      f.inputs :duties,:as=>:select,:collection => Duty.all
    end
    f.inputs "审批环节" do
      f.has_many :work_flow_steps do |p|
        p.input  :is_self_dep
        p.input  :dep
        p.input  :duty
        p.input  :max_amount
      end
    end
    f.buttons
  end
end
