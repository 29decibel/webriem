#coding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require	File.expand_path(File.dirname(__FILE__)	+	'/../factories' )

describe DocHead do
  #create a doc_head
  before do
    #three person in the same dep
    @dep = Factory(:dep)
    @app_duty = Factory(:duty)
    @doc_meta_info = Factory(:doc_meta_info,:code=>'88')
    #applyer
    @applyer = Factory(:person,:dep=>@dep,:duty=>@app_duty)
    #create duty
    @duty1 = Factory(:duty)
    @duty2 = Factory(:duty)
    #create person
    @p1 = Factory(:person,:duty=>@duty1,:dep=>@dep)
    @p2 = Factory(:person,:duty=>@duty2,:dep=>@dep)
    #work flow steps here
    @step1 = Factory(:work_flow_step,:duty=>@duty1,:is_self_dep=>true)
    @step2 = Factory(:work_flow_step,:duty=>@duty2,:is_self_dep=>true)
    #create work flow
    @wf = Factory(:work_flow)
    @wf.duties<<@app_duty
    @wf.doc_meta_infos<<@doc_meta_info
    @wf.work_flow_steps<<@step1
    @wf.work_flow_steps<<@step2

    #create the doc
    @doc = Factory(:doc_head,:doc_type=>@doc_meta_info.code.to_i,:person=>@applyer)
  end

  it "doc should have doc_no when init " do
    doc = Factory(:doc_head)
    doc.doc_no.should_not be_nil
  end

  it "doc should not be valid when reciver's amount not equals total amount" do
    pending 'consider to valid'
    # doc = Factory(:doc_head)
    # doc.cp_doc_details << Factory(:cp_doc_detail,:ori_amount=>12,:rate=>2,:doc_head=>doc)
    # doc.recivers << Factory(:reciver,:doc_head => doc)
    # doc.should_not be_valid
    # #change reciver to ok
    # r = doc.recivers.first
    # r.amount = 12*2
    # doc.should be_valid
  end

  it "should be in the work flow process when begin_work" do
    @doc.submit
    @doc.should be_processing

    @doc.approve
    @doc.should be_approved

    @doc.pay
    @doc.should be_paid
  end

  it "should be in the rejected state when reject" do
    @doc.submit
    @doc.reject
    @doc.should be_rejected
  end

  it "should be in the right person to approve the doc within the same dep" do
    @doc.submit
    
    @doc.approvers.should == [@p1.id,@p2.id].join(',')
    @doc.current_approver_id.should == @p1.id

    @doc.work_flow.should == @wf

    @doc.next_approver
    @doc.current_approver_id.should == @p2.id
    @doc.approver.should == @p2

    @doc.next_approver
    @doc.should be_approved
  end

  it "should have a work flow info with the current approver" do
    @doc.submit
    @doc.next_approver('you are good')
    @doc.work_flow_infos.count.should == 1

    @doc.work_flow_infos.first.comments.should == 'you are good'
    @doc.work_flow_infos.first.approver_id.should == @p1.id
  end

  it "should have the reject approver's comments" do
    @doc.submit
    @doc.decline('not fine')

    @doc.work_flow_infos.count.should == 1
    @doc.work_flow_infos.first.approver_id.should ==@p1.id
    @doc.work_flow_infos.first.comments.should == 'not fine'
  end

  it "if real person exist , should go the work flow from real person" do
    #three person in the same dep
    dep = Factory(:dep)
    real_person_dep = Factory(:dep)

    app_duty = Factory(:duty)
    real_person_duty = Factory(:duty)

    doc_meta_info = Factory(:doc_meta_info,:code=>'88')
    #applyer
    applyer = Factory(:person,:dep=>dep,:duty=>app_duty)
    real_person = Factory(:person,:dep=>real_person_dep,:duty=>real_person_duty)

    #create duty
    duty1 = Factory(:duty)
    duty2 = Factory(:duty)
    #create person
    p1 = Factory(:person,:duty=>duty1,:dep=>dep)
    p2 = Factory(:person,:duty=>duty2,:dep=>dep)

    p3 = Factory(:person,:duty=>duty1,:dep=>real_person_dep)
    p4 = Factory(:person,:duty=>duty2,:dep=>real_person_dep)
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
    doc = Factory(:doc_head,:doc_type=>doc_meta_info.code.to_i,:person=>applyer,:real_person=>real_person)
    doc.work_flow.should be_nil

    # now can find the work_flow
    wf.duties<<real_person_duty
    doc.work_flow.should_not be_nil

    doc.submit
    doc.approvers.should == [p3.id,p4.id].join(',')
    doc.current_approver_id.should == p3.id
  end

  it "should use the user selected person to approve" do
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
    p3 = Factory(:person,:duty=>duty1,:dep=>dep)
    p4 = Factory(:person,:duty=>duty1,:dep=>dep)
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

    doc.approvers_from_work_flow_step(doc.work_flow.work_flow_steps.first).count.should == 3
    doc.submit
    doc.current_approver_id.should == p1.id

    doc.reject
    doc.update_attribute :selected_approver_id,p4.id
    doc.submit
    doc.current_approver_id.should == p4.id
  end

  it "should not let the person approve if the doc amount is less than the max_amount" do
    #three person in the same dep
    dep = Factory(:dep)

    app_duty = Factory(:duty)

    doc_meta_info = Factory(:doc_meta_info,:code=>'1')
    #applyer
    applyer = Factory(:person,:dep=>dep,:duty=>app_duty)

    #create duty
    duty1 = Factory(:duty)
    duty2 = Factory(:duty)
    #create person
    p1 = Factory(:person,:duty=>duty1,:dep=>dep)
    p2 = Factory(:person,:duty=>duty2,:dep=>dep)
    p3 = Factory(:person,:duty=>duty1,:dep=>dep)
    p4 = Factory(:person,:duty=>duty1,:dep=>dep)
    #work flow steps here
    step1 = Factory(:work_flow_step,:duty=>duty1,:is_self_dep=>true,:max_amount=>8000)
    step2 = Factory(:work_flow_step,:duty=>duty2,:is_self_dep=>true)
    #create work flow
    wf = Factory(:work_flow)
    wf.duties<<app_duty
    wf.doc_meta_infos<<doc_meta_info
    wf.work_flow_steps<<step1
    wf.work_flow_steps<<step2

    #create the doc
    doc = Factory(:doc_head,:doc_type=>doc_meta_info.code.to_i,:person=>applyer)
    doc.borrow_doc_details << Factory(:borrow_doc_detail,:ori_amount=>1000,:rate=>7)
    doc.save

    doc.submit
    doc.approvers.split(',').count.should == 1
    doc.current_approver_id.should == p2.id

    doc.reject
    doc.borrow_doc_details.first.update_attribute :apply_amount,9000
    doc.save
    puts doc.total_amount

    doc.submit
    doc.approvers.split(',').count.should == 2
    doc.current_approver_id.should == p1.id
    
  end
end
