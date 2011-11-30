#coding: utf-8
#地区表： [DistrictClass]  cDCCode 地区编码     cDCName 地区名称     iDCGrade 地区级次  bDCEnd  是否末级
#行业表：【tradeclass】cTradeCCode 行业编码   cTradeCName行业名称    iTradeCGrade行业分类级次    bTradeCEnd是否末级
#代理商：[customer] cCusCode 客户编码   cCusAbbName  客户名称
namespace :u8_service do
  desc "sync districts"
  task :sync_districts => :environment do
    sql = 'select cDCCode as code,cDCName as name,iDCGrade as grade,bDCEnd as is_end from DistrictClass'
    results = U8Service.exec_sql(sql)
    puts results
    results.each do |dr|
      d = U8District.find_by_code(dr['code']) || U8District.new
      d.code=dr['code']
      d.name=dr['name']
      d.grade=dr['grade']
      d.is_end=dr['is_end']
      d.save
    end
  end


  desc "sync districts"
  task :sync_trades => :environment do
    sql = 'select cTradeCCode as code,cTradeCName as name,iTradeCGrade as grade,bTradeCEnd as is_end from tradeclass'
    results = U8Service.exec_sql(sql)
    puts results
    results.each do |dr|
      d = U8Trade.find_by_code(dr['code']) || U8Trade.new
      d.code=dr['code']
      d.name=dr['name']
      d.grade=dr['grade']
      d.is_end=dr['is_end']
      d.save
    end
  end


  desc "sync districts"
  task :sync_customers => :environment do
    sql = 'select cCusCode as code,cCusAbbName as name from customer'
    results = U8Service.exec_sql(sql)
    puts results
    results.each do |dr|
      d = U8Customer.find_by_code(dr['code']) || U8Customer.new
      d.code=dr['code']
      d.name=dr['name']
      d.save
    end
  end

end
