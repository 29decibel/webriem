#coding: utf-8
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
    logger.info "#{RAILS_ROOT}/doc/skdocs/sk_dep.csv"
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_dep.csv").each_line do |line|
  	  logger.info line
  		parts=line.split(",")
  		logger.info line
  		#here is create a dep  		
  		dep= Dep.new
  		dep.u8dep_code=>parts[0].strip
  		dep.code=>parts[1].strip
  		dep.name=>parts[2].strip
  		dep.start_date=>Time.now
  		dep.end_date=>Time.new("2999-12-31"))
  		dep.parent_dep=Dep.find_by_code(parts[3].strip)
  		dep.save
  	end
  	#duty here-------------------------------------------------------
  	Duty.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_duty.csv").each_line do |line|
  		parts=line.split(",")
  		#here is create a duty
  		Duty.create(:name=>parts[1].strip,:code=>parts[0].strip)
  	end
  	#person here---------------------------------------------------
  	Person.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_person.csv").each_line do |line|
  		parts=line.split(",")
  		#here is create a person
  		person=Person.new(:code=>parts[0].strip,:name=>parts[1].strip)
  		#set the gender
  		if parts[2]=="男" or parts[2]=="M"
  			person.gender=1
  		elsif parts[2]=="女" or parts[2]=="F"
  			person.gender=2
  		else
  			person.gender=0
  		end
  		#set the dep
  		person.dep=Dep.find_by_code(parts[3].strip)
  		person.duty=Duty.find_by_code(parts[6].strip)
  		person.phone=parts[7].strip
  		person.e_mail=parts[8].strip
  		person.ID_card=parts[9].strip
  		person.bank_no=parts[10].strip
  		person.bank=parts[11].strip
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
  		Account.create(:name=>parts[0].strip,:account_no=>parts[1].strip)
  	end
  	#create the currency
  	Currency.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_currency.csv").each_line do |line|
  		parts=line.split(",")
  		Currency.create(:code=>parts[0].strip,:name=>parts[1].strip,:default_rate=>parts[2])
  	end
  	#create the fee
  	Fee.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_fee.csv").each_line do |line|
  		parts=line.split(",")
  		fee=Fee.new(:code=>parts[0].strip,:name=>parts[1].strip)
  		fee.parent_fee=Fee.find_by_name(parts[3])
  		fee.save
  	end
  	#create the transportation
  	Transportation.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_transportation.csv").each_line do |line|
  		parts=line.split(",")
  		Transportation.create(:code=>parts[0].strip,:name=>parts[1].strip)
  	end
  	#create the region type
  	RegionType.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_region_type.csv").each_line do |line|
  		parts=line.split(",")
  		RegionType.create(:code=>parts[0].strip,:name=>parts[1].strip)
  	end
  	#create the region
  	Region.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_region.csv").each_line do |line|
  		parts=line.split(",")
  		region=Region.new(:code=>parts[0].strip,:name=>parts[1].strip)
  		region.region_type=RegionType.find_by_code(parts[2])
  		region.save
  	end
  	#create the project
  	Project.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_project.csv").each_line do |line|
  		parts=line.split(",")
  		Project.create(:code=>parts[0].strip,:name=>parts[1].strip)
  	end
  	#create the fee standard
  	FeeStandard.delete_all
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_fee_standard.csv").each_line do |line|
  		parts=line.split(",")
  		fs=FeeStandard.new(:amount=>parts[4].to_f)
  		fs.duty=Duty.find_by_name(parts[0].strip)
  		fs.fee=Fee.find_by_name(parts[1].strip)
  		fs.region_type=RegionType.find_by_name(parts[2].strip)
  		fs.currency=Currency.find_by_code(parts[3].strip)
  		fs.save
  	end  	
  end
end
