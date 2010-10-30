#coding: utf-8
class TaskController < ApplicationController
  def my_docs
    if current_user.person
      redirect_to :controller=>"model_search",:action=>"index",:class_name=>"DocHead",:pre_condition=>"person_id=#{current_user.person.id}",:lookup=>true,:title=>"我的单据",:layout=>true
    else
      render "task/no_rights_error"
    end
  end
  #docs need to approve
  def docs_to_approve
    if current_user.person
      redirect_to :controller=>"model_search",:action=>"index",:class_name=>"DocHead",:pre_condition=>"doc_state=1 and work_flow_step_id is not null",:filter_method=>"docs_to_approve",:lookup=>true,:title=>"需要审批的单据",:multicheck=>true,:checkable=>true,:batch_approve=>true,:layout=>true
    else
      render "task/no_rights_error"
    end  
  end
  #the docs need to pay
  def docs_to_pay
    if current_user.person and current_user.person.person_type and current_user.person.person_type.code=="CA"
      redirect_to :controller=>"model_search",:action=>"index",:class_name=>"DocHead",:pre_condition=>"doc_state=2 and paid is null",:lookup=>true,:title=>"需要付款的单据",:multicheck=>true,:checkable=>true,:batch_pay=>true,:layout=>true
    else
      render "task/no_rights_error"
    end
  end
  #the docs that has been approved
  def docs_approved
    if current_user.person
      redirect_to :controller=>"model_search",:action=>"index",:class_name=>"DocHead",:joins=>"work_flow_infos",:pre_condition=>"work_flow_infos.people_id=#{current_user.person.id}",:lookup=>true,:title=>"审批过的单据",:layout=>true
    else
      render "task/no_rights_error"
    end
  end
  #docs already paid
  def docs_paid
    if current_user.person
      redirect_to :controller=>"model_search",:action=>"index",:class_name=>"DocHead",:pre_condition=>"doc_state=2 and paid=1",:lookup=>true,:title=>"已经付款的单据",:layout=>true
    else
      render "task/no_rights_error"
    end
  end
  def import
    @errors=[]
    #dep here------------------------------------------------------------
    Dep.delete_all
    logger.info "#{RAILS_ROOT}/doc/skdocs/sk_dep.csv"
  	File.open("#{RAILS_ROOT}/doc/skdocs/sk_dep.csv").each_line do |line|
  	  #logger.info line
  		parts=line.split(",")
  		#here is create a dep  		
  		dep= Dep.new(:u8dep_code=>parts[0].strip,:code=>parts[1].strip,:name=>parts[2].strip,:start_date=>Time.now,:end_date=>"2999-12-31".to_date)
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
  	logger.info "#{RAILS_ROOT}/doc/skdocs/sk_person.csv"
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
  		if person.valid?
  			person.save
  			#create a user
	  		u=User.find_by_name(person.code)
	  		if u
	  		  u.destroy
			  end
	  		User.create(:name => person.code, :email => person.e_mail, :password => "123456",:password_confirmation=>"123456")		
  		else
  			@errors<<"#{person.code}==#{person.name}==#{person.errors}"
  			logger.info "#{person.code}==#{person.name}==#{person.errors}"
  		end
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
	#
  def private_cmd
  	PersonType.create(:name=>"MTA",:code=>"MTA")
	  PersonType.create(:name=>"管理担当",:code=>"MN")
  end
end
