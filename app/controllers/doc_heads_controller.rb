#coding: utf-8
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
    #set the apply person to the current login user
    @doc_head.person=current_person
    #build some new doc details
    @doc_head.reim_details.build if @doc_head.doc_type==3
    @doc_head.cp_doc_details.build if @doc_head.doc_type==1 or  @doc_head.doc_type==2
    @doc_head.rec_notice_details.build if @doc_head.doc_type==4
    @doc_head.recivers.build if @doc_head.doc_type<=4
    @doc_head.inner_remittances.build if @doc_head.doc_type==5
    @doc_head.inner_transfers.build if @doc_head.doc_type==6
    @doc_head.inner_cash_draws.build if @doc_head.doc_type==7
    @doc_head.buy_finance_products.build if @doc_head.doc_type==8
    @doc_head.redeem_finance_products.build if @doc_head.doc_type==9
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
    if @doc_head.update_attributes(params[:doc_head])
      @message="更新成功"
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
    @doc_head = DocHead.find(params[:id])
    @doc_head.doc_state=1
    #找到当前单据类型对应的审批流，然后取第一个流程中的那个step_id
    @doc_head.work_flow_step_id=@doc_head.work_flows.first.id
    @doc_head.save
    @message="开始进入审批环节，审批期间单据不能修改"
    respond_to do |format|
      format.js { render "shared/show_result",:locals=>{:doc_head=>@doc_head}}
    end
  end
end
