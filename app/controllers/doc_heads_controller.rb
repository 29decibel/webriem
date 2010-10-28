#coding: utf-8
#require "ruby-debug"
#借款单—JK  付款单—FK  报销单—BX  收款通知单—SK  结汇申请单—JH  转账申请单—ZH  现金提取申请单—XJ  购买理财产品通知单—GL  赎回理财产品通知单—SL
#9=>"差旅费报销",10=>"交通费报销",11=>"住宿费报销",12=>"工作餐费报销",13=>"加班餐费报销",14=>"加班交通费报销",15=>"业务交通费报销",16=>"福利费用报销"
DOC_TYPE_PREFIX={1=>"JK",2=>"FK",3=>"SK",4=>"JH",5=>"ZH",6=>"XJ",7=>"GL",8=>"SL",9=>"BXCL",10=>"BXJT",11=>"BXZS",12=>"BXGZ",13=>"BXJBC",14=>"BXJBJ",15=>"BXYW",16=>"BXFL"}
class DocHeadsController < ApplicationController
  #get the current login user and fetch the person info by the user name 
  #and this user name is stored in the person table as person.code
  def current_person
    person=Person.find_by_code(current_user.name)
  end
  # GET /doc_heads
  # GET /doc_heads.xml
  def index
    #get the specific docs by the doc_type passed by querystring
    @doc_heads = DocHead.where("doc_type=?",params[:doc_type].to_i)
    @doc_type=params[:doc_type].to_i
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @doc_heads }
    end
  end

  # GET /doc_heads/1
  # GET /doc_heads/1.xml
  def show
    @doc_head = DocHead.find(params[:id])
    @doc_type = @doc_head.doc_type
    #if the doc is current needed to be approved by current person,then new a @work_flow_info
    if @doc_head.doc_state==1
      if @doc_head.approver==current_user.person
        @work_flow_info=WorkFlowInfo.new
      end
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @doc_head }
    end
  end

  # GET /doc_heads/new
  # GET /doc_heads/new.xml
  def new
    @doc_head = DocHead.new
    @doc_head.doc_state = 0
    #set the doctype to the paras passed in
    @doc_head.doc_type=params[:doc_type].to_i
    @doc_head.doc_no=DOC_TYPE_PREFIX[@doc_head.doc_type]+Time.now.strftime("%Y%d%m")+DocHead.all.count.to_s.rjust(4,"0")
    @doc_head.apply_date=Time.now
    @doc_head.dep=current_person.dep
    @doc_type = @doc_head.doc_type
    #set the apply person to the current login user
    @doc_head.person=current_person
    #build some new doc details
    @doc_head.cp_doc_details.build if @doc_head.doc_type==1 or  @doc_head.doc_type==2
    @doc_head.rec_notice_details.build if @doc_head.doc_type==3
    reciver=@doc_head.recivers.build
    #init the reciver's info to current person
    reciver.bank=current_person.bank
    reciver.bank_no=current_person.bank_no
    reciver.company=current_person.name
    if @doc_head.doc_type==1
    	reciver.direction=1
	elsif @doc_head.doc_type==2
		reciver.direction=0
	end
	reciver.settlement=Settlement.find_by_code("02")
    #build one related stuff
    @doc_head.build_inner_remittance if @doc_head.doc_type==4
    @doc_head.build_inner_transfer if @doc_head.doc_type==5
    @doc_head.build_inner_cash_draw if @doc_head.doc_type==6
    @doc_head.build_buy_finance_product if @doc_head.doc_type==7
    @doc_head.build_redeem_finance_product if @doc_head.doc_type==8
    #暂时每次都创建一个审批流填写信息
    @doc_head.work_flow_infos.build
    #render
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @doc_head }
    end
  end


  # POST /doc_heads
  # POST /doc_heads.xml
  def create
    @doc_head = DocHead.new(params[:doc_head])
    @doc_head.doc_state = 0
    @doc_head.cp_doc_remain_amount=@doc_head.total_apply_amount
    #add the offset info
    if params[:offset_info]
      params[:offset_info].each_value do |value|
        @doc_head.reim_cp_offsets.build(value)
      end
    end
    if @doc_head.save
      @message="创建成功"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@doc_head)}
    end
  end

  # PUT /doc_heads/1
  # PUT /doc_heads/1.xml
  def update
    @doc_head = DocHead.find(params[:id])
    #add the offset info
    if params[:offset_info]
      params[:offset_info].each_value do |value|
        @doc_head.reim_cp_offsets.build(value)
      end
    end
    if @doc_head.update_attributes(params[:doc_head])
      @doc_head.update_attribute(:cp_doc_remain_amount,@doc_head.total_apply_amount)
      @message="更新成功"
      if @doc_head.approver==current_user.person
        @work_flow_info=WorkFlowInfo.new
      end
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@doc_head)}
    end
  end

  # DELETE /doc_heads/1
  # DELETE /doc_heads/1.xml
  def destroy
    @doc_head = DocHead.find(params[:id])
    @doc_head.destroy

    respond_to do |format|
      format.html { redirect_to(doc_heads_url) }
      format.xml  { head :ok }
    end
  end
  #将单据进入审批阶段
  def begin_work
    @doc_head = DocHead.find(params[:doc_id])
    @doc_head.doc_state=1
    @doc_head.approver_id=params[:approver_id]
    #找到当前单据类型对应的审批流，然后取第一个流程中的那个step_id
    @doc_head.work_flow_step_id=@doc_head.work_flows.first.id
    @doc_head.save
    #notice the person who need to approve this doc
    #WorkFlowMailer.notice_need_approve(@doc_head.approver,@doc_head).deliver
    #now i am using the delayed job to do this
    Delayed::Job.enqueue MailingJob.new(:notice_need_approve, @doc_head.approver,@doc_head) 
    @message="开始进入审批环节，审批期间单据不能修改"
    if @doc_head.approver==current_user.person
      @work_flow_info=WorkFlowInfo.new
    end
    respond_to do |format|
      format.js { render "shared/show_result"}
    end
  end
  #撤销单据的审批
  def giveup
  	@doc_head = DocHead.find(params[:doc_id])
  	@doc_head.doc_state=0
  	@doc_head.approver_id=nil
  	@doc_head.save
  	@message="单据已经撤回，现在可以进行修改"
    respond_to do |format|
      format.js { render "shared/show_result"}
    end
  end
  #付款
  def pay
    #debugger
    @doc_head=DocHead.find(params[:doc_id].to_i)
    @doc_head.update_attribute(:paid,1)
    #debugger
    @message="付款成功"
    render "shared/show_result"
  end
end
