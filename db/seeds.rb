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
Menu.create(:name=>'my_docs',:title=>'我的单据',:path=>'/task/my_docs',:menu_type=>1)
Menu.create(:name=>'my_docs',:title=>'需要审批单据',:path=>'/task/docs_to_approve',:menu_type=>1)
Menu.create(:name=>'roles',:title=>'权限设置',:path=>'/model_search/index?class_name=Role&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'deps',:title=>'部门',:path=>'/model_search/index?class_name=Dep&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'duties',:title=>'职务',:path=>'/model_search/index?class_name=Duty&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'people',:title=>'员工',:path=>'/model_search/index?class_name=Person&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'fees',:title=>'费用类型',:path=>'/model_search/index?class_name=Fee&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'regions',:title=>'地区',:path=>'/model_search/index?class_name=Region&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'transportations',:title=>'交通方式',:path=>'/model_search/index?class_name=Transportation&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'lodgings',:title=>'住宿方式',:path=>'/model_search/index?class_name=Lodging&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'settlements',:title=>'结算方式',:path=>'/model_search/index?class_name=Settlement&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'fee_standards',:title=>'费用标准',:path=>'/model_search/index?class_name=FeeStandard&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'projects',:title=>'项目',:path=>'/model_search/index?class_name=Project&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'budgets',:title=>'预算数据',:path=>'/model_search/index?class_name=Budget&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'currencies',:title=>'币种',:path=>'/model_search/index?class_name=Currency&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'subjects',:title=>'科目设置',:path=>'/model_search/index?class_name=Subject&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'accounts',:title=>'账户设置',:path=>'/model_search/index?class_name=Account&lookup=true&addable=true&deletable=true',:menu_type=>0)
Menu.create(:name=>'work_flows',:title=>'审批流设置',:path=>'/model_search/index?class_name=WorkFlow&lookup=true&addable=true&deletable=true',:menu_type=>0)
#docs menu goes here
DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"交际费报销",11=>"加班费报销",12=>"普通费用报销",13=>"福利费用报销"}
(1..13).each do |num|
  Menu.create(:name=>num.to_s,:title=>DOC_TYPES[num],:path=>"/doc_heads/new?doc_type=#{num}",:menu_type=>1)
end
#the default business_types
BusinessType.delete_all
BusinessType.create(:name=>"借款");
BusinessType.create(:name=>"报销");
BusinessType.create(:name=>"其他");
#region types
RegionType.delete_all
RegionType.create(:name=>"一级地区");
RegionType.create(:name=>"二级地区");
RegionType.create(:name=>"韩国");
RegionType.create(:name=>"海外");
RegionType.create(:name=>"其他");
#the default person type
PersonType.delete_all
PersonType.create(:name=>"HR",:code=>"HR")
PersonType.create(:name=>"财务主管",:code=>"FI")
PersonType.create(:name=>"出纳",:code=>"CA")
#the default user
if !User.find_by_name("admin")
  User.create(:name=>"admin",:email=>"mike.d.198411@gmail.com",:password=>"adminadmin",:password_confirmation=>"adminadmin")
end
#set up the duty and dep
#Duty.create(:name=>"part长1",:code=>"d001")
#Duty.create(:name=>"part长2",:code=>"d002")
#Duty.create(:name=>"team长1",:code=>"d003")
#Duty.create(:name=>"team长2",:code=>"d004")
#Duty.create(:name=>"HR",:code=>"d005")
#Duty.create(:name=>"出纳",:code=>"d006")
#Duty.create(:name=>"部门经理",:code=>"d007")
#Duty.create(:name=>"研发经理",:code=>"d008")
#set up the dep
#Dep.create(:name=>"研发1部",:code=>"dep001")
#Dep.create(:name=>"研发2部",:code=>"dep002")
#Dep.create(:name=>"研发3部",:code=>"dep003")
#Dep.create(:name=>"研发4部",:code=>"dep004")
#Dep.create(:name=>"财务部门",:code=>"dep005")
#Dep.create(:name=>"HR部门",:code=>"dep006")
