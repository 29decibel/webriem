#coding: utf-8
class SubjectsController < ApplicationController
  # GET /subjects
  # GET /subjects.xml
  def index
    @resources=Subject.all
    @model_s_name="subject"
    @model_p_name="subjects"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  def edit
    @subject = Subject.find(params[:id])
    respond_to do |format|
      format.js {render "basic_setting/edit",:locals=>{:resource=>@subject}}
    end   
  end
  # GET /subjects/1
  # GET /subjects/1.xml
  def show
    @subject = Subject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subject }
    end
  end

  # GET /subjects/new
  # GET /subjects/new.xml
  def new
    @subject = Subject.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @subject }
      format.js { render "basic_setting/new",:locals=>{:resource=>@subject }}
    end
  end

  # POST /subjects
  # POST /subjects.xml
  def create
    @subject = Subject.new(params[:subject])
    if !@subject.save
      render "basic_setting/new",:locals=>{:resource=>@subject }
    else
      redirect_to index
    end
  end

  # PUT /subjects/1
  # PUT /subjects/1.xml
  def update
    @subject = Subject.find(params[:id])
    if !@subject.update_attributes(params[:subject])
      render "basic_setting/edit",:locals=>{:resource=>@subject }
    else
      render "basic_setting/update",:locals=>{:resource=>@subject}
    end
  end

  # DELETE /subjects/1
  # DELETE /subjects/1.xml
  def destroy
    @subject = Subject.find(params[:id])
    @subject.destroy

    respond_to do |format|
      format.html { redirect_to(subjects_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@subject} }
    end
  end
end
