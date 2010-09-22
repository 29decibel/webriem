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
    #render
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @doc_head }
    end
  end

  # GET /doc_heads/1/edit
  def edit
    @doc_head = DocHead.find(params[:id])
  end

  # POST /doc_heads
  # POST /doc_heads.xml
  def create
    @doc_head = DocHead.new(params[:doc_head])
    respond_to do |format|
      if @doc_head.save
        format.html { redirect_to(@doc_head, :notice => '单据添加成功') }
        format.xml  { render :xml => @doc_head, :status => :created, :location => @doc_head }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @doc_head.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /doc_heads/1
  # PUT /doc_heads/1.xml
  def update
    @doc_head = DocHead.find(params[:id])

    respond_to do |format|
      if @doc_head.update_attributes(params[:doc_head])
        format.html { redirect_to(@doc_head, :notice => '单据修改成功.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @doc_head.errors, :status => :unprocessable_entity }
      end
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
  
  #this action is respond to the add reciver method
  def add_reciver_remote
    respond_to do |format|
      format.js
    end
  end
end
