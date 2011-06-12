#coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require	File.expand_path(File.dirname(__FILE__)	+	'/../factories' )

describe DocHead do
  #create a doc_head
  before do
  end

  it "doc should have doc_no when init " do
    doc = Factory(:doc_head)
    doc.doc_no.should_not be_nil
  end

  it "doc should not be valid when reciver's amount not equals total amount" do
    doc = Factory(:doc_head)
    doc.cp_doc_details << Factory(:cp_doc_detail,:ori_amount=>12,:rate=>2,:doc_head=>doc)
    doc.recivers << Factory(:reciver,:doc_head => doc)
    doc.should_not be_valid
    #change reciver to ok
    r = doc.recivers.first
    r.amount = 12*2
    doc.should be_valid
  end

  it "should be in the work flow process when begin_work" do
    pending '....'
  end

  it "should be in the right person to approve the doc within the same dep" do
    #three person in the same dep
    dep = Factory(:dep)
    app_duty = Factory(:duty)
    doc_meta_info = Factory(:doc_meta_info,:code=>'88')
    #applyer
    applyer = Factory(:person,:dep=>dep,:duty=>app_duty)
    #create duty
    duty1 = Factory(:duty)
    duty2 = Factory(:duty)
    #create person
    p1 = Factory(:person,:duty=>duty1,:dep=>dep)
    p2 = Factory(:person,:duty=>duty2,:dep=>dep)
    #work flow steps here
    step1 = Factory(:work_flow_step,:duty=>duty1,:is_self_dep=>true)
    step2 = Factory(:work_flow_step,:duty=>duty2,:is_self_dep=>true)
    #create work flow
    wf = Factory(:work_flow)
    wf.duties<<app_duty
    wf.doc_meta_infos<<doc_meta_info
    wf.work_flow_steps<<step1
    wf.work_flow_steps<<step2

    #create the doc
    doc = Factory(:doc_head,:doc_type=>doc_meta_info.code.to_i,:person=>applyer)
    doc.set_approvers
    puts doc.approvers

    doc.work_flow.should == wf

    puts doc.inspect
    puts wf.inspect
    puts wf.work_flow_steps
    doc.next_approver
    doc.approver.should == p1
    doc.next_approver
    doc.approver.should == p2
  end
end
