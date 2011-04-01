#coding: utf-8
class PeopleController < ApplicationController
  # GET /people
  # GET /people.xml
  def index
    @resources=Person.page(params[:page]).per(20)
    @model_s_name="person"
    @model_p_name="people"
    respond_to do |format|
      format.xml  { render :xml => @resources }
      format.js   { render "basic_setting/index"}
    end
  end

  def all
   sep="     " 
   txt=""
   Person.all.each do |p|
     txt<<p.name
     txt<<sep
     txt<<p.code
     txt<<sep
     txt<<p.e_mail
     txt<<sep
     txt<<p.phone
     txt<<sep
     txt<<p.dep.name
     txt<<sep
     txt<<(p.duty==nil ? "" : p.duty.name)
     txt<<sep
     txt<<p.bank_no
     txt<<"\r\n"
   end
   render :text=>txt,:layout=>false
  end
  # GET /people/1
  # GET /people/1.xml
  def show
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @person }
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @person }
      format.js { render "basic_setting/new",:locals=>{:resource=>@person} }
    end
  end


  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])
    user=User.new(:name => @person.code, :email => @person.e_mail, :password => "123456",:password_confirmation=>"123456")
    if @person.save and user.valid?
      user.save
      @people=Person.all
      render "basic_setting/create",:locals=>{:resource=>@person,:resources=>@people}
    else
      render "basic_setting/new",:locals=>{:resource=>@person }
    end
  end
  def edit
    @person = Person.find(params[:id])
    render "basic_setting/edit",:locals=>{:resource=>@person}
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])
    @person.attributes=params[:person]
    #user=User.find_by_name(@person.code)
    #user.attributes={:name=>@person.code,:e_mail=>@person.e_mail,:password_confirmation=>user.password}
    if @person.update_attributes params[:person] and @person.valid?
      render "basic_setting/update",:locals=>{:resource=>@person}
    else
      render "basic_setting/edit",:locals=>{:resource=>@person}
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    #delete the user account
    user=User.find_by_name(@person.code)
    if user
      user.destroy
    end
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
      format.js { render "basic_setting/destroy",:locals=>{:resource=>@person} }
    end
  end
end
