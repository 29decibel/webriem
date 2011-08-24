#coding: utf-8
namespace :update do
  desc "update oes"
  task :all => :environment do
    # doc_types on work_flow to relation
  end

  desc "create admin user"
  task :create_admin => :environment do
    AdminUser.create :name=>'mike',:email=>'mike.d.1984@gmail.com',:password=>'123456',:password_confirmation=>'123456' unless AdminUser.find_by_name('mike')
  end

  desc "delete exist user who do not relate to person"
  task :clear_user => :environment do
    User.all.each do |u|
      u.destroy unless u.person
    end
  end

  desc "pick pay_doc_details from cp_doc_details"
  task :pick_pay_doc => :environment do
    BorrowDocDetail.joins(:doc_head).where("doc_heads.doc_type=2").all.each do |b|
      PayDocDetail.create b.attributes
    end
  end

  desc "pick rd_communicates from rd_work_meals"
  task :pick_rd_comm => :environment do
    RdWorkMeal.joins(:doc_head).where("doc_heads.doc_type=10").all.each do |w|
      RdCommunicate.create w.attributes
    end
  end

  desc "update rd_benefit's ori_amount"
  task :rd_benefit => :environment do
    RdBenefit.all.each {|r| r.update_attribute :ori_amount,r.apply_amount}
  end

  desc "assign new doc state"
  task :doc_state => :environment do
    states = {0=>'un_submit',1=>'processing',2=>'approved',3=>'paid'}
    DocHead.all.each {|d| d.update_attribute :state,states[d.doc_state]}
  end

  desc "update roles"
  task :roles => :menus do
    Role.all.each do |r|
      r.menu_ids.split(',').each do |menu_id|
        r.menus << Menu.find(menu_id)
      end
    end
  end

  DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"交际费报销",11=>"加班费报销",12=>"普通费用报销",13=>"福利费用报销",14=>'固定资产单据'}
  DOC_TYPES_EN = {1=>"d_Borrow",2=>"d_PayDoc",3=>"d_ReciveNotice",4=>"d_Redeem",5=>"d_Transfer",6=>"d_CashDraw",7=>"d_BuyFinanceProduct",8=>"d_RedeemFinanceProduct",9=>"d_TravelExpense",10=>"d_EntertainmentExpense",11=>"d_OvertimeWork",12=>"d_GeneralExpense",13=>"d_Wage",14=>'d_FixedProperty'}

  desc "create doc meta infos"
  task :create_doc_metas => :environment do
    #create doc meta infos here
    DocMetaInfo.delete_all
    DOC_TYPES.each_pair do |k,v|
      DocMetaInfo.create :name=>v,:code=>k
    end
  end
  
  desc "assign old person id of work_flow_infos"
  task :work_flow_info => :environment do
    WorkFlowInfo.all.each {|wfi| wfi.update_attribute :approver_id,wfi.person_id}
  end

  desc "update work flows"
  task :work_flow => :create_doc_metas do
    WorkFlow.all.each do |wf|
      wf.doc_types.split(';').each do |meta_doc_id|
        wf.doc_meta_infos << DocMetaInfo.find_by_code(meta_doc_id)
      end
    end
  end

  desc "update some fee's feetype"
  task :fee_type => :environment do
    Fee.find_by_code('0303').update_attribute(:fee_type,'RdTravel')
    Fee.find_by_code('0302').update_attribute(:fee_type,'RdLodging')
    Fee.find_by_code('0601').update_attribute(:fee_type,'RdExtraWorkMeal')
  end

  desc "create menus"
  task :menus => :environment do
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
    Menu.create(:name=>"doc_rows",:path=>"/doc_rows",:menu_type=>1,:menu_category=>basic_cate)

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
    Menu.create(:name=>"d_FixedProperty",:path=>"/doc_heads/new?doc_type=14",:menu_type=>1,:menu_category=>docs_cate3)
  end

  DOC_TYPE_PREFIX={1=>"JK",2=>"FK",3=>"SK",4=>"JH",5=>"ZH",6=>"XJ",
          7=>"GL",8=>"SL",9=>"BXCL",10=>"BXJJ",11=>"BXJB",12=>"BXFY",
          13=>"BXFL",14=>"GDZC"}
  desc "change doc type number to english prefix"
  task :doc_type_prefix => :environment do
    DocHead.all.each do |d|
      d.update_attribute(:doc_type,DOC_TYPE_PREFIX[d.doc_type.to_i].downcase)
    end
  end

  desc "fix doc type"
  task :fix_doc_type => :environment do
    DocHead.where("doc_type='nono'").all.each do |d|
      doc_type = DOC_TYPE_PREFIX.select{|k,v| v==d.doc_no[0..-13]}.keys.first
      d.update_attribute(:doc_type,doc_type)
    end
    #DocHead.all.each do |d|
    #  d.update_attribute(:doc_type,d.doc_type.downcase)
    #end
  end

  desc "update system configs"
  task :system_config => :environment do
    SystemConfig.create :key=>'default_settlement',:value=>'01' unless SystemConfig.find_by_key("default_settlement")
    SystemConfig.create :key=>'default_currency',:value=>'RMB' unless SystemConfig.find_by_key("default_currency")
    SystemConfig.create :key=>'casher_duty_code',:value=>'011' unless SystemConfig.find_by_key("casher_duty_code")
  end

  desc "reset all users password"
  task :reset_password => :environment do
    User.all.each do |u|
      u.reset_password '123456','123456'
    end
  end

  desc "reset non use fi and hr adjust amount"
  task :reset_adjust_amount => :clear_singles do
    %w(RdTravel RdTransport RdLodging RdExtraWorkMeal RdExtraWorkCar OtherRiem RdBenefit).each do |resource|
      rt = Kernel.const_get(resource)
      rt.all.each do |item|
        if item.hr_amount == item.apply_amount
          item.update_attribute :hr_amount,nil
        end
        if item.fi_amount == item.apply_amount
          item.update_attribute :fi_amount,nil
        end
      end
    end
    Reciver.all.each do |r|
      if r.hr_amount == r.amount
        r.update_attribute :hr_amount,nil
      end
      if r.fi_amount == r.amount
        r.update_attribute :fi_amount,nil
      end
    end
  end

  desc "fetch old type column from fixed property table"
  task :migrate_fixed_property => :environment do
    FixedProperty.all.each {|f| f.update_attribute :fp_type,f.type}
  end

  desc "clear poor childs"
  task :clear_singles => :environment do
    %w(RdTravel RdTransport RdLodging RdExtraWorkMeal RdExtraWorkCar OtherRiem RdBenefit Reciver).each do |resource|
      rt = Kernel.const_get(resource)
      ok_doc_head_ids = rt.joins(:doc_head).map(&:doc_head_id)
      delete_count = rt.where("doc_head_id not in (?)",ok_doc_head_ids).delete_all
      puts "#{delete_count} #{resource} deleted......"
    end   
  end

  desc "update u8code name column"
  task :u8code => :environment do
    U8code.all.each {|u| u.update_attribute :name,"#{u.ccode},#{u.ccode_name}"}
  end

end

