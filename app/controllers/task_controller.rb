#coding: utf-8
require 'rubygems'
require 'excelsior'
class TaskController < ApplicationController
  def my_docs
    if current_user.person
      redirect_to :controller=>"model_search",:action=>"index",:class_name=>"DocHead",:pre_condition=>"person_id=#{current_user.person.id}",:lookup=>true,:title=>"我的单据"
    else
      @my_docs=[]
    end
  end
  def docs_to_approve
    #我的审批单据，也可以进行过滤，我作为审批角色的单据
    #where("doc_state=1 and work_flow_step_id is not null")
    #.select {|doc| doc.approver.id==current_user.person.id}
    if current_user.person
      if current_user.person.person_type and current_user.person.person_type.code=="CA"
        @docs_to_approve=DocHead.where("doc_state=2 and paid is null")
      else
        @docs_to_approve=DocHead.where("doc_state=1 and work_flow_step_id is not null").select {|doc| doc.approver==current_user.person}
      end
    else
      @docs_to_approve=[]
    end    
  end
  def import
    @errors=[]
    #dep here------------------------------------------------------------
    Dep.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_dep.csv").each_line do |line|
  		parts=line.split(",")
  		#here is create a dep
  		puts line  		
  		dep= Dep.new(:u8dep_code=>parts[0],:code=>parts[1],:name=>parts[2],:start_date=>Time.now,:end_date=>Time.new("2999-12-31"))
  		dep.parent_dep=Dep.find_by_code(parts[3])
  		if dep.save
  		  puts "save ok..."
		  else
		    puts dep.errors
	    end
  	end
  	#duty here-------------------------------------------------------
  	Duty.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_duty.csv").each_line do |line|
  		parts=line.split(",")
  		puts line
  		#here is create a duty
  		Duty.create(:name=>parts[1],:code=>parts[0])
  	end
  	#person here---------------------------------------------------
  	Person.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_person.csv").each_line do |line|
  		parts=line.split(",")
  		puts line
  		#here is create a person
  		person=Person.new(:code=>parts[0],:name=>parts[1])
  		#set the gender
  		if parts[2]=="男" or parts[2]=="M"
  			person.gender=1
  		elsif parts[2]=="女" or parts[2]=="F"
  			person.gender=2
  		else
  			person.gender=0
  		end
  		#set the dep
  		person.dep=Dep.find_by_code(parts[3])
  		person.duty=Duty.find_by_code(parts[6])
  		person.phone=parts[7]
  		person.e_mail=parts[8]
  		person.ID_card=parts[9]
  		person.bank_no=parts[10]
  		person.bank=parts[11]
  		person.save
  		@errors<<person.errors
  		#create a user
  		u=User.find_by_name(person.code)
  		if u
  		  u.destroy
		  end
  		User.create(:name => person.code, :email => person.e_mail, :password => "123456",:password_confirmation=>"123456")		
  	end
  	#create account here
  	Account.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_account.csv").each_line do |line|
  		parts=line.split(",")
  		puts line
  		Account.create(:name=>parts[0],:account_no=>parts[1])
  	end
  	#create the currency
  	Currency.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_currency.csv").each_line do |line|
  		parts=line.split(",")
  		puts line
  		Currency.create(:code=>parts[0],:name=>parts[1],:default_rate=>parts[2])
  	end
  	#create the fee
  	Fee.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_fee.csv").each_line do |line|
  		parts=line.split(",")
  		puts line
  		fee=Fee.new(:code=>parts[0],:name=>parts[1])
  		fee.parent_fee=Fee.find_by_name(parts[3])
  		fee.save
  	end
  	#create the transportation
  	Transportation.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_transportation.csv").each_line do |line|
  		parts=line.split(",")
  		puts line
  		Transportation.create(:code=>parts[0],:name=>parts[1])
  	end
  	#create the region type
  	RegionType.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_region_type.csv").each_line do |line|
  		parts=line.split(",")
  		puts line
  		RegionType.create(:code=>parts[0],:name=>parts[1])
  	end
  	#create the region
  	Region.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_region.csv").each_line do |line|
  		parts=line.split(",")
  		region=Region.new(:code=>parts[0],:name=>parts[1])
  		region.region_type=RegionType.find_by_code(parts[2])
  		region.save
  	end
  	#create the project
  	Project.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_project.csv").each_line do |line|
  		parts=line.split(",")
  		Project.create(:code=>parts[0],:name=>parts[1])
  	end
  end
end
