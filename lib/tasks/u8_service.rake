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

  desc "sync districts"
  task :sync_products => :environment do
    sql = "select cinvcode as code,cinvname as name,cinvstd as std,cinvccode as category from inventory WHERE (cInvCCode LIKE '01%')"
    Product.where("category not like '01%'").delete_all
    results = U8Service.exec_sql(sql)
    puts results
    results.each do |dr|
      d = Product.find_by_code(dr['code']) || Product.new
      d.code=dr['code']
      d.name=dr['name']
      d.category=dr['category']
      d.std=dr['std']
      d.save
    end
  end

  desc "import u8 codes"
  task :sync_codes => :environment do
    begin
      sql = 'select cclass,ccode,ccode_name,igrade,bend,cexch_name,bperson,bitem,bdept from code'
      u8codes= U8Service.exec_sql sql
      #never delete 
      this_time_count=0
      puts u8codes
      u8codes.each do |u8_model|
        #current year not exist then create
        model = U8code.where("year =#{Time.now.year} and ccode=#{u8_model["ccode"]}").first || U8code.new
        model.cclass=u8_model["cclass"]
        model.ccode=u8_model["ccode"]
        model.ccode_name=u8_model["ccode_name"]
        model.igrade=u8_model["igrade"]
        model.bend=u8_model["bend"]
        model.cexch_name=u8_model["cexch_name"]
        model.bperson=u8_model["bperson"]
        model.bitem=u8_model["bitem"]
        model.bdept=u8_model["bdept"]
        model.year=Time.now.year
        model.save
        this_time_count=this_time_count+1
      end
    rescue Exception=>msg
      Rails.logger.error "^^^^^^^^^^^^^^^can't get the u8 serivce to get the codes info"
      Rails.logger.error "#{msg}"
    end
  end


  desc "import u8 deps"
  task :sync_deps => :environment do
    U8Dep.delete_all
     begin
      sql = 'select cDepCode,bDepEnd,cDepName,iDepGrade from Department'
      u8deps= U8Service.exec_sql sql
      #never delete 
      this_time_count=0
      puts u8deps
      u8deps.each do |u8_model|
        model = U8Dep.find_by_cdepcode(u8_model['cDepCode']) || U8Dep.new
        model.cdepcode=u8_model["cDepCode"]
        model.bdepend=u8_model["bDepEnd"]
        model.cdepname=u8_model["cDepName"]
        model.idepgrade=u8_model["iDepGrade"]
        model.save
        this_time_count=this_time_count+1
      end
    rescue Exception=>msg
      Rails.logger.error "^^^^^^^^^^^^^^^can't get the u8 serivce to get the departments info"
      Rails.logger.error "#{msg}"
    end
  end


end
