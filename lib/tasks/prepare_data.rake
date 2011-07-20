#coding: utf-8
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
namespace :data do
  desc "create system fee types"
  task :create_fees => :environment do
    puts 'begin creating fees......'
    Fee.create :name=>'借款单据',:code=>'01',:fee_type=>'BorrowDocDetail',:end_date=>10.years.from_now
    Fee.create :name=>'付款单据',:code=>'02',:fee_type=>'PayDocDetail',:end_date=>10.years.from_now
    Fee.create :name=>'差旅费',:code=>'03',:fee_type=>'__',:end_date=>10.years.from_now
      Fee.create :name=>'差旅费补助',:code=>'0301',:fee_type=>'RdTravel',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('03').id
      Fee.create :name=>'交通费',:code=>'0302',:fee_type=>'RdTransport',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('03').id
      Fee.create :name=>'住宿费',:code=>'0303',:fee_type=>'RdLodging',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('03').id
      Fee.create :name=>'其它费用',:code=>'0304',:fee_type=>'OtherRiem',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('03').id
    Fee.create :name=>'交际费',:code=>'04',:fee_type=>'RdCommunicate',:end_date=>10.years.from_now
    Fee.create :name=>'加班费',:code=>'05',:fee_type=>'__',:end_date=>10.years.from_now
      Fee.create :name=>'加班车费',:code=>'0501',:fee_type=>'RdExtraWorkCar',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('05').id
      Fee.create :name=>'加班餐费',:code=>'0502',:fee_type=>'RdExtraWorkMeal',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('05').id
    Fee.create :name=>'普通费用',:code=>'06',:fee_type=>'__',:end_date=>10.years.from_now
      Fee.create :name=>'普通费用报销',:code=>'0601',:fee_type=>'CommonRiem',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('06').id
      Fee.create :name=>'工作餐费',:code=>'0602',:fee_type=>'RdWorkMeal',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('06').id
      Fee.create :name=>'业务交通费',:code=>'0603',:fee_type=>'RdCommonTransport',:end_date=>10.years.from_now,:parent_fee_id => Fee.find_by_code('06').id
    Fee.create :name=>'福利费用',:code=>'07',:fee_type=>'RdBenefit',:end_date=>10.years.from_now   
    puts 'fees created successfuly...'
  end
end

