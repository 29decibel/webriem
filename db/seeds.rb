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
Menu.create(:name=>"d_Borrow",:path=>"/doc_heads/new?doc_type=1",:menu_type=>1,:menu_category=>docs_cate1)
Menu.create(:name=>"d_PayDoc",:path=>"/doc_heads/new?doc_type=2",:menu_type=>1,:menu_category=>docs_cate1)
#docs 3
Menu.create(:name=>"d_TravelExpense",:path=>"/doc_heads/new?doc_type=9",:menu_type=>1,:menu_category=>docs_cate2)
Menu.create(:name=>"d_EntertainmentExpense",:path=>"/doc_heads/new?doc_type=10",:menu_type=>1,:menu_category=>docs_cate2)
Menu.create(:name=>"d_OvertimeWork",:path=>"/doc_heads/new?doc_type=11",:menu_type=>1,:menu_category=>docs_cate2)
Menu.create(:name=>"d_GeneralExpense",:path=>"/doc_heads/new?doc_type=12",:menu_type=>1,:menu_category=>docs_cate2)
Menu.create(:name=>"d_Wage",:path=>"/doc_heads/new?doc_type=13",:menu_type=>1,:menu_category=>docs_cate2)
#docs 2
Menu.create(:name=>"d_ReciveNotice",:path=>"/doc_heads/new?doc_type=3",:menu_type=>1,:menu_category=>docs_cate3)
Menu.create(:name=>"d_Redeem",:path=>"/doc_heads/new?doc_type=4",:menu_type=>1,:menu_category=>docs_cate3)
Menu.create(:name=>"d_Transfer",:path=>"/doc_heads/new?doc_type=5",:menu_type=>1,:menu_category=>docs_cate3)
Menu.create(:name=>"d_CashDraw",:path=>"/doc_heads/new?doc_type=6",:menu_type=>1,:menu_category=>docs_cate3)
Menu.create(:name=>"d_BuyFinanceProduct",:path=>"/doc_heads/new?doc_type=7",:menu_type=>1,:menu_category=>docs_cate3)
Menu.create(:name=>"d_RedeemFinanceProduct",:path=>"/doc_heads/new?doc_type=8",:menu_type=>1,:menu_category=>docs_cate3)


#docs menu goes here
DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"交际费报销",11=>"加班费报销",12=>"普通费用报销",13=>"福利费用报销"}
DOC_TYPES_EN = {1=>"d_Borrow",2=>"d_PayDoc",3=>"d_ReciveNotice",4=>"d_Redeem",5=>"d_Transfer",6=>"d_CashDraw",7=>"d_BuyFinanceProduct",8=>"d_RedeemFinanceProduct",9=>"d_TravelExpense",10=>"d_EntertainmentExpense",11=>"d_OvertimeWork",12=>"d_GeneralExpense",13=>"d_Wage"}

#region typesde
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
#here is the config helper
ConfigHelper.delete_all
ConfigHelper.create(:key=>"doc_count",:value=>"0")
#create the admin user
AdminUser.delete_all
AdminUser.create(:name=>"admin",:email=>"mike.d.198411@gmail.com",:password=>"123456",:password_confirmation=>"123456")
#the default user
User.delete_all
User.create(:name=>"staff",:email=>"mike.d.198411@gmail.com",:password=>"123456",:password_confirmation=>"123456")
#create duty
Duty.delete_all
duty=Duty.create :name=>"AdminUseOnly",:code=>"admin_use_only"
#create person
Person.delete_all
Person.create :name=>"staff",:duty=>duty,:code=>"staff",:phone=>"123456",:e_mail=>"mike.d.1984@gmail.com",:ID_card=>"aaa",:bank_no=>"1111",:bank=>"CNNC"
# create system config
# system config can only be edit value
# but not change key and delete
SystemConfig.delete_all
SystemConfig.create :key=>'default_settlement',:value=>'set settlement code here'
SystemConfig.create :key=>'default_currency',:value=>'set currency_code here'
SystemConfig.create :key=>'casher_duty_code',:value=>'set casher code here'
# system fee types
# same with the doc row
# 只对借款、付款和所有的报销单据进行系统级别费用类型创建
# 其他单据由于没有预算控制，所以不对其进行特殊关照
# 可以把这些内容放到一个task中去
#DocResourceTypes = 
#  { '借款单据'=>'BorrowDocDetail',
#    '付款单据'=>'PayDocDetail',
#    '差旅费'=>'RdTravel','交通费'=>'RdTransport','住宿费'=>'RdLodging','其它费用'=>'OtherRiem',
#    '交际费用'=>'RdCommunicate',
#    '加班车费'=>'RdExtraWorkCar','加班餐费'=>'RdExtraWorkMeal',
#    '普通费用'=>'CommonRiem','工作餐费'=>'RdWorkMeal','业务交通费'=>'RdCommonTransport',
#    '福利费用'=>'RdBenefit'}
Fee.delete_all
Fee.create :name=>'借款单据',:code=>'01',:fee_type=>'BorrowDocDetail',:end_date=>10.years.from_now
Fee.create :name=>'付款单据',:code=>'02',:fee_type=>'PayDocDetail',:end_date=>10.years.from_now
Fee.create :name=>'差旅费',:code=>'03',:fee_type=>'',:end_date=>10.years.from_now
  Fee.create :name=>'差旅费',:code=>'0301',:fee_type=>'RdTravel',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('03').id
  Fee.create :name=>'交通费',:code=>'0302',:fee_type=>'RdTransport',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('03').id
  Fee.create :name=>'住宿费',:code=>'0303',:fee_type=>'RdLodging',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('03').id
  Fee.create :name=>'其它费用',:code=>'0304',:fee_type=>'OtherRiem',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('03').id
Fee.create :name=>'交际费',:code=>'04',:fee_type=>'RdCommunicate',:end_date=>10.years.from_now
Fee.create :name=>'加班费',:code=>'05',:fee_type=>'',:end_date=>10.years.from_now
  Fee.create :name=>'加班车费',:code=>'0501',:fee_type=>'RdExtraWorkCar',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('05').id
  Fee.create :name=>'加班餐费',:code=>'0502',:fee_type=>'RdExtraWorkMeal',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('05').id
Fee.create :name=>'普通费用',:code=>'06',:fee_type=>'',:end_date=>10.years.from_now
  Fee.create :name=>'普通费用',:code=>'0601',:fee_type=>'CommonRiem',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('06').id
  Fee.create :name=>'工作餐费',:code=>'0602',:fee_type=>'RdWorkMeal',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('06').id
  Fee.create :name=>'业务交通费',:code=>'0603',:fee_type=>'RdCommonTransport',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('06').id
Fee.create :name=>'福利费用',:code=>'07',:fee_type=>'RdBenefit',:end_date=>10.years.from_now
