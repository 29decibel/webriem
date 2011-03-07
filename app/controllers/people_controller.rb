#coding: utf-8
class PeopleController < ApplicationController
  # GET /people
  # GET /people.xml
  def index
    #redirect_to :controller=>"model_search",:action=>"index",:class_name=>"Person",:lookup=>true,:addable=>true,:deletable=>true,:layout=>true
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
    end
  end


  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])
    user=User.new(:name => @person.code, :email => @person.e_mail, :password => "123456",:password_confirmation=>"123456")
    if user.valid? and @person.valid?
      user.save
      @person.save
      @message="#{I18n.t('controller_msg.create_ok')}"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@person)+get_error_messages(user)}
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])
    @person.attributes=params[:person]
    #user=User.find_by_name(@person.code)
    #user.attributes={:name=>@person.code,:e_mail=>@person.e_mail,:password_confirmation=>user.password}
    if @person.valid?
      #user.update_attributes :name=>@person.code,:e_mail=>@person.e_mail
      @person.update_attributes params[:person]
      @message="#{I18n.t('controller_msg.update_ok')}"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(user)+get_error_messages(@person)}
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
    end
  end
end
