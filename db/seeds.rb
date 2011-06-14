#coding: utf-8
#the menus
MenuCategory.delete_all
basic_cate=MenuCategory.create :name=>"我的单据",:description=>"here is the category of basic settings"
docs_cate1=MenuCategory.create :name=>"借付款单",:description=>"here is the category of create docs"
docs_cate2=MenuCategory.create :name=>"报销单据",:description=>"here is the category of create docs"
docs_cate3=MenuCategory.create :name=>"内部单据",:description=>"here is the category of create docs"

Menu.delete_all
Menu.create(:name=>'my_docs',:path=>'/task/my_docs',:menu_type=>1,:menu_category=>basic_cate)
Menu.create(:name=>'docs_to_approve',:path=>'/task/docs_to_approve',:menu_type=>1,:menu_category=>basic_cate)
Menu.create(:name=>'docs_to_pay',:path=>'/task/docs_to_pay',:menu_type=>1,:menu_category=>basic_cate)
Menu.create(:name=>'docs_paid',:path=>'/task/docs_paid',:menu_type=>1,:menu_category=>basic_cate)
Menu.create(:name=>'docs_approved',:path=>'/task/docs_approved',:menu_type=>1,:menu_category=>basic_cate)

#docs 1
Menu.create(:name=>"借款单",:path=>"/doc_heads/new?doc_type=1",:menu_type=>1,:menu_category=>docs_cate1)
Menu.create(:name=>"付款单",:path=>"/doc_heads/new?doc_type=2",:menu_type=>1,:menu_category=>docs_cate1)
#docs 3
Menu.create(:name=>"差旅费报销",:path=>"/doc_heads/new?doc_type=9",:menu_type=>1,:menu_category=>docs_cate2)
Menu.create(:name=>"交际费报销",:path=>"/doc_heads/new?doc_type=10",:menu_type=>1,:menu_category=>docs_cate2)
Menu.create(:name=>"加班费报销",:path=>"/doc_heads/new?doc_type=11",:menu_type=>1,:menu_category=>docs_cate2)
Menu.create(:name=>"普通费用报销",:path=>"/doc_heads/new?doc_type=12",:menu_type=>1,:menu_category=>docs_cate2)
Menu.create(:name=>"福利费用报销",:path=>"/doc_heads/new?doc_type=13",:menu_type=>1,:menu_category=>docs_cate2)
#docs 2
Menu.create(:name=>"收款通知单",:path=>"/doc_heads/new?doc_type=3",:menu_type=>1,:menu_category=>docs_cate3)
Menu.create(:name=>"结汇",:path=>"/doc_heads/new?doc_type=4",:menu_type=>1,:menu_category=>docs_cate3)
Menu.create(:name=>"转账",:path=>"/doc_heads/new?doc_type=5",:menu_type=>1,:menu_category=>docs_cate3)
Menu.create(:name=>"现金提取",:path=>"/doc_heads/new?doc_type=6",:menu_type=>1,:menu_category=>docs_cate3)
Menu.create(:name=>"购买理财产品",:path=>"/doc_heads/new?doc_type=7",:menu_type=>1,:menu_category=>docs_cate3)
Menu.create(:name=>"赎回理财产品",:path=>"/doc_heads/new?doc_type=8",:menu_type=>1,:menu_category=>docs_cate3)


#docs menu goes here
DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"交际费报销",11=>"加班费报销",12=>"普通费用报销",13=>"福利费用报销"}
DOC_TYPES_EN = {1=>"d_Borrow",2=>"d_PayDoc",3=>"d_ReciveNotice",4=>"d_Redeem",5=>"d_Transfer",6=>"d_CashDraw",7=>"d_BuyFinanceProduct",8=>"d_RedeemFinanceProduct",9=>"d_TravelExpense",10=>"d_EntertainmentExpense",11=>"d_OvertimeWork",12=>"d_GeneralExpense",13=>"d_Wage"}

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
PersonType.create(:name=>"同PART长",:code=>"PART")
#Currency
Currency.delete_all
Currency.create :name=>"人民币",:code=>"RMB",:default_rate=>1
Currency.create :name=>"美元",:code=>"USD",:default_rate=>6
Currency.create :name=>"韩币",:code=>"KON",:default_rate=>200
#create doc meta infos here
DocMetaInfo.delete_all
DOC_TYPES.each_pair do |k,v|
  DocMetaInfo.create :name=>v,:code=>k
end
DocMetaInfo.create :name=>"",:code=>''
#here is the config helper
ConfigHelper.delete_all
ConfigHelper.create(:key=>"doc_count",:value=>"0")
#the default user
User.delete_all
User.create(:name=>"admin",:email=>"mike.d.198411@gmail.com",:password=>"123456",:password_confirmation=>"123456")
#create duty
Duty.delete_all
duty=Duty.create :name=>"AdminUseOnly",:code=>"admin_use_only"
#create person
Person.delete_all
Person.create :name=>"admin",:duty=>duty,:code=>"admin",:phone=>"123456",:e_mail=>"mike.d.1984@gmail.com",:ID_card=>"aaa",:bank_no=>"1111",:bank=>"CNNC"

