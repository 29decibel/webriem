#coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
#the menus
Menu.delete_all
Menu.create(:name=>'my_docs',:name_en=>"MyDocs",:title=>'我的单据',:path=>'/task/my_docs',:menu_type=>1)
Menu.create(:name=>'docs_to_approve',:name_en=>"DocsToApprove",:title=>'需要审批单据',:path=>'/task/docs_to_approve',:menu_type=>1)
Menu.create(:name=>'docs_to_pay',:name_en=>"DocsToPay",:title=>'需要付款的单据',:path=>'/task/docs_to_pay',:menu_type=>1)
Menu.create(:name=>'docs_paid',:name_en=>"DocsPaid",:title=>'已经付款的单据',:path=>'/task/docs_paid',:menu_type=>1)
Menu.create(:name=>'docs_approved',:name_en=>"DocsApproved",:title=>'审批过的单据',:path=>'/task/docs_approved',:menu_type=>1)
Menu.create(:name=>'roles',:name_en=>"Roles",:title=>'权限设置',:path=>'/model_search/index?class_name=Role&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'deps',:name_en=>"Deps",:title=>'部门',:path=>'/model_search/index?class_name=Dep&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'duties',:name_en=>"Duty",:title=>'职务',:path=>'/model_search/index?class_name=Duty&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'people',:name_en=>"Stuff",:title=>'员工',:path=>'/model_search/index?class_name=Person&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'fees',:name_en=>"Fees",:title=>'费用类型',:path=>'/model_search/index?class_name=Fee&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'regions',:name_en=>"Regions",:title=>'地区',:path=>'/model_search/index?class_name=Region&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'transportations',:name_en=>"Transportations",:title=>'交通方式',:path=>'/model_search/index?class_name=Transportation&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'lodgings',:name_en=>"Lodgings",:title=>'住宿方式',:path=>'/model_search/index?class_name=Lodging&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'settlements',:name_en=>"Settlements",:title=>'结算方式',:path=>'/model_search/index?class_name=Settlement&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'fee_standards',:name_en=>"FeeStandards",:title=>'费用标准',:path=>'/model_search/index?class_name=FeeStandard&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'projects',:name_en=>"Projects",:title=>'项目',:path=>'/model_search/index?class_name=Project&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'budgets',:name_en=>"Budgets",:title=>'预算数据',:path=>'/model_search/index?class_name=Budget&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'extra_work_standards',:name_en=>"ExtraWorkStandards",:title=>'加班费标准',:path=>'/model_search/index?class_name=ExtraWorkStandard&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'currencies',:name_en=>"Currency",:title=>'币种',:path=>'/model_search/index?class_name=Currency&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'subjects',:name_en=>"Subjects",:title=>'科目设置',:path=>'/model_search/index?class_name=Subject&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'accounts',:name_en=>"Accounts",:title=>'账户设置',:path=>'/model_search/index?class_name=Account&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
Menu.create(:name=>'work_flows',:name_en=>"WorkFlows",:title=>'审批流设置',:path=>'/model_search/index?class_name=WorkFlow&lookup=true&addable=true&deletable=true&layout=true',:menu_type=>0)
#docs menu goes here
DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"交际费报销",11=>"加班费报销",12=>"普通费用报销",13=>"福利费用报销"}
DOC_TYPES_EN = {1=>"Borrow",2=>"PayDoc",3=>"ReciveNotice",4=>"Redeem",5=>"Transfer",6=>"CashDraw",7=>"BuyFinanceProduct",8=>"RedeemFinanceProduct",9=>"TravelExpense",10=>"EntertainmentExpense",11=>"OvertimeWork",12=>"GeneralExpense",13=>"Wage"}

(1..13).each do |num|
  Menu.create(:name=>num.to_s,:name_en=>DOC_TYPES_EN[num],:title=>DOC_TYPES[num],:path=>"/doc_heads/new?doc_type=#{num}",:menu_type=>1)
end
#the default business_types
#BusinessType.delete_all
BusinessType.create(:name=>"借款");
BusinessType.create(:name=>"报销");
BusinessType.create(:name=>"其他");
#region typesde
#RegionType.delete_all
RegionType.create(:name=>"一级地区");
RegionType.create(:name=>"二级地区");
RegionType.create(:name=>"韩国");
RegionType.create(:name=>"海外");
RegionType.create(:name=>"其他");
#the default person type
#PersonType.delete_all
PersonType.create(:name=>"HR",:code=>"HR")
PersonType.create(:name=>"财务主管",:code=>"FI")
PersonType.create(:name=>"出纳",:code=>"CA")
PersonType.create(:name=>"MTA",:code=>"MTA")
PersonType.create(:name=>"管理担当",:code=>"MN")
#here is the config helper
ConfigHelper.delete_all
ConfigHelper.create(:key=>"doc_count",:value=>"0")
#the default user
if !User.find_by_name("admin")
  User.create(:name=>"admin",:email=>"mike.d.198411@gmail.com",:password=>"adminadmin",:password_confirmation=>"adminadmin")
end
#import docs
#dep here------------------------------------------------------------
Dep.delete_all
Rails.logger.info "#{RAILS_ROOT}/doc/skdocs/sk_dep.csv"
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
Rails.logger.info "#{RAILS_ROOT}/doc/skdocs/sk_person.csv"
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
		Rails.logger.info "#{person.code}==#{person.name}==#{person.errors}"
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
DocHead.delete_all
