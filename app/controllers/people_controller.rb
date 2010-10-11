#coding: utf-8
class PeopleController < ApplicationController
  # GET /people
  # GET /people.xml
  def index
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @people }
    end
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
    create_or_update_user_account(@person.code,@person.e_mail)
    if @person.save
      @message="创建成功"
      render "shared/show_result"
    else
      #write some codes
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@person)}
    end
  end
  
  def create_or_update_user_account(name,email)
    user=User.find_by_name(name)
    if user
      user.update_attributes :name=>name,:email=>email
    else
      User.create(:name => name, :email => email, :password => "123456",:password_confirmation=>"123456")
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person])
      create_or_update_user_account(@person.code,@person.e_mail)
      @message="更新成功"
      render "shared/show_result"
    else
      #写一些校验出错信息
      render "shared/errors",:locals=>{:error_msg=>get_error_messages(@person)}
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    #delete the user account
    user=User.find_by_name(@person.code)
    user.destroy
    @person.destroy

    respond_to do |format|
      format.html { redirect_to(people_url) }
      format.xml  { head :ok }
    end
  end
end
