#coding: utf-8
require "#{Rails.root}/app/u8service/api.rb"
class DocHead < ActiveRecord::Base
  belongs_to :fee
  belongs_to :dep
  belongs_to :person
  belongs_to :currency
  belongs_to :afford_dep, :class_name => "Dep", :foreign_key => "afford_dep_id"
  belongs_to :upload_file
  belongs_to :real_person, :class_name => "Person", :foreign_key => "real_person_id"
  blongs_to_name_attr :fee
  blongs_to_name_attr :dep
  blongs_to_name_attr :afford_dep
  blongs_to_name_attr :person
  blongs_to_name_attr :project
  blongs_to_name_attr :currency
  validates_presence_of :doc_no, :on => :create, :message => "单据号必输"
  validates_presence_of :apply_date, :on => :create, :message => "申请日期必须输入"
  validates_uniqueness_of :doc_no, :on => :create, :message => "已经存在相同的单据号"
  #has many recivers and cp_doc_details
  has_many :recivers, :class_name => "Reciver", :foreign_key => "doc_head_id",:dependent => :destroy
  #has many c and p doc details
  has_many :cp_doc_details, :class_name => "CpDocDetail", :foreign_key => "doc_head_id",:dependent => :destroy
  #many rec notice details
  has_many :rec_notice_details,:class_name=>"RecNoticeDetail",:foreign_key=>"doc_head_id",:dependent=>:destroy
  #only one reum details
  has_one :inner_remittance, :class_name => "InnerRemittance", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_one :inner_transfer, :class_name => "InnerTransfer", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_one :inner_cash_draw, :class_name => "InnerCashDraw", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_one :buy_finance_product, :class_name => "BuyFinanceProduct", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_one :redeem_finance_product, :class_name => "RedeemFinanceProduct", :foreign_key => "doc_head_id",:dependent=>:destroy
  #审批流
  has_many :work_flow_infos, :class_name => "WorkFlowInfo", :foreign_key => "doc_head_id",:dependent=>:destroy
  #======================================================================
  #,:reject_if => lambda { |a| a[:sequence].blank? }
  accepts_nested_attributes_for :recivers, :allow_destroy => true
  accepts_nested_attributes_for :cp_doc_details , :allow_destroy => true
  accepts_nested_attributes_for :rec_notice_details , :allow_destroy => true
  #here is the samn reason for 
  accepts_nested_attributes_for :inner_remittance , :allow_destroy => true
  accepts_nested_attributes_for :inner_transfer , :allow_destroy => true
  accepts_nested_attributes_for :inner_cash_draw , :allow_destroy => true
  accepts_nested_attributes_for :buy_finance_product ,:allow_destroy => true
  accepts_nested_attributes_for :redeem_finance_product , :allow_destroy => true
  #审批流
  accepts_nested_attributes_for :work_flow_infos ,:reject_if => lambda { |a| a[:is_ok].blank? }, :allow_destroy => true
  #here is about reim=============================
  belongs_to :project
  #here is the details
  has_many :rd_travels, :class_name => "RdTravel", :foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_transports, :class_name => "RdTransport", :foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_lodgings, :class_name => "RdLodging",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_work_meals, :class_name => "RdWorkMeal",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_extra_work_cars, :class_name => "RdExtraWorkCar",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_extra_work_meals, :class_name => "RdExtraWorkMeal",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_benefits, :class_name => "RdBenefit",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_common_transports, :class_name => "RdCommonTransport",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :reim_split_details, :class_name => "ReimSplitDetail",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :common_riems, :class_name => "CommonRiem", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_many :other_riems, :class_name => "OtherRiem", :foreign_key => "doc_head_id",:dependent=>:destroy
  #here is for the vouch info
  has_many :vouches,:class_name=>"Vouch",:foreign_key=>"doc_head_id",:dependent=>:destroy
  #warn 这里最好不要都reject,因为reject的根本就不会进行校验，而且不会爆出任何错误信息
  accepts_nested_attributes_for :reim_split_details , :allow_destroy => true
  accepts_nested_attributes_for :rd_extra_work_meals , :allow_destroy => true
  accepts_nested_attributes_for :rd_benefits , :allow_destroy => true
  accepts_nested_attributes_for :rd_common_transports , :allow_destroy => true
  accepts_nested_attributes_for :rd_extra_work_cars , :allow_destroy => true
  accepts_nested_attributes_for :rd_work_meals , :allow_destroy => true
  accepts_nested_attributes_for :rd_lodgings , :allow_destroy => true
  accepts_nested_attributes_for :rd_travels , :allow_destroy => true
  accepts_nested_attributes_for :rd_transports , :allow_destroy => true
  accepts_nested_attributes_for :common_riems , :allow_destroy => true
  accepts_nested_attributes_for :other_riems , :allow_destroy => true
  #default_scope :order => 'updated_at DESC'
  #the great offset info here
  has_many :reim_cp_offsets,:class_name => "RiemCpOffset",:foreign_key=>"reim_doc_head_id",:dependent=>:destroy
  has_many :cp_docs,:through=>:reim_cp_offsets,:source=>:cp_doc_head
  Doc_State={0=>"未提交",1=>"审批中",2=>"审批通过",3=>"已付款"}
  DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"交际费报销",11=>"加班费报销",12=>"普通费用报销",13=>"福利费用报销"}
  #validate the amout is ok
  validate :must_equal,:dep_and_project_not_null,:project_not_null_if_charge,:dep_is_end
  def project_not_null_if_charge
    errors.add(:base,"收款单明细 项目不能为空") if doc_type==2 and cp_doc_details.size>0 and !cp_doc_details.all? {|c| c.project_id!=nil}
  end
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if (afford_dep and afford_dep.sub_deps.count>0)
  end
  def must_equal
    errors.add(:base, "报销总金额#{total_fi_amount}，- 冲抵总金额#{offset_amount}，不等于 收款总金额#{reciver_amount}") if total_fi_amount-offset_amount!=reciver_amount and doc_type>=9 and doc_type<=12
    errors.add(:base,"借款总金额#{total_fi_amount} 不等于 收款总金额#{reciver_amount}") if total_fi_amount!=reciver_amount and doc_type<=2
    #the amount of issplit should be equal to total_fi_amount
    errors.add(:base,"分摊总金额#{split_total_amount} 不等于 单据总金额#{total_fi_amount}") if is_split==1 and split_total_amount!=total_fi_amount
  end
  def dep_and_project_not_null
    #debugger
    errors.add(:base,"表头项目或费用承担部门不能为空") if (doc_type==9 or doc_type==11) and is_split==0 and (dep_id==nil or project_id==nil)
  end
  #the total apply amount
  def total_apply_amount
    get_doc_amount(:apply_amount)
  end
  #the total hr amount
  def total_hr_amount
    get_doc_amount(:hr_amount)
  end
  #the total fi amount
  def total_fi_amount
    get_doc_amount(:fi_amount)
  end
  #get amount for specific doc type
  #asumme every detail has a amount attribute
  def amount_for(doc_detail_name)
    amount=0
    details=self.send(doc_detail_name)
    if details
      #has_many
      if details.respond_to? :count
        details.each do |d|
          amount=d.amount+amount
        end
      else
        amount=details.amount
      end
    end
    amount.ceil(2)
  end
  #get doc amount by type ---apply_amount? hr_amount? fi_amount?
  def get_doc_amount(type)
    total=0
    if doc_type==1 or doc_type==2
      cp_doc_details.each do |cp|
        next if cp.marked_for_destruction? || cp.apply_amount==nil
        total+=cp.apply_amount
      end
    end
    if doc_type==3
      rec_notice_details.each do |rd_detail|
        next if  rd_detail.marked_for_destruction? || rd_detail.amount==nil
        total+=rd_detail.amount
      end
    end
    if doc_type==4 and inner_remittance!=nil
      total=inner_remittance.amount || 0
    end
    if doc_type==5 and inner_transfer !=nil
      total=inner_transfer.amount || 0
    end
    if doc_type==6 and inner_cash_draw!=nil
      inner_cash_draw.cash_draw_items.each do |c_item|
        next if c_item.apply_amount==nil or c_item.marked_for_destruction?
        total+=c_item.apply_amount
      end
    end
    if doc_type==7 and buy_finance_product!=nil
      total=buy_finance_product.amount
    end
    if doc_type==8 and redeem_finance_product!=nil
      total=redeem_finance_product.amount
    end
    if doc_type==9
      [rd_travels,rd_transports,rd_lodgings,other_riems].each do |rd|
        rd.each do |rd_detail|
          next if  rd_detail.marked_for_destruction? || rd_detail.send(type)==nil
          total+=rd_detail.send(type)         
        end
      end
    end
    if doc_type==10
      rd_work_meals.each do |rd|
        next if rd.marked_for_destruction? || rd.apply_amount==nil
        total+=rd.apply_amount
      end
    end
    if doc_type==11
      [rd_extra_work_cars,rd_extra_work_meals].each do |rd|
        rd.each do |rd_detail|
          next if  rd_detail.marked_for_destruction? || rd_detail.send(type)==nil
          total+=rd_detail.send(type)         
        end
      end
    end
    if doc_type==12
      [rd_common_transports,rd_work_meals,common_riems].each do |rd|
        rd.each do |rd_detail|
          next if  rd_detail.marked_for_destruction? || rd_detail.apply_amount==nil
          total+=rd_detail.apply_amount
        end
      end
    end
    if doc_type==13
      rd_benefits.each do |rd_detail|
        next if  rd_detail.marked_for_destruction? || rd_detail.send(type)==nil
        total+=rd_detail.send(type)
      end
    end
    total
  end
  #the split total amount
  def split_total_amount
    total=0
    reim_split_details.each do |split|
      next if split.marked_for_destruction?
      total+=split.percent_amount if split.percent_amount
    end
    total
  end
  #offset info record am i hava offset
  def offset_info(reim_doc_id)
    #debugger
    RiemCpOffset.where("reim_doc_head_id=? and cp_doc_head_id=#{self.id}",reim_doc_id).first
  end
  def offset_amount
    total=0
    reim_cp_offsets.each do |offset|
      total+=offset.amount
    end
    total
  end
  def available_offset_cp_docs(current_person_id)
    cp_offset_docs=DocHead.where("person_id=? and doc_type=1 and cp_doc_remain_amount>0 and doc_state=3",current_person_id).all
    (cp_offset_docs+cp_docs.all).uniq
  end
  #reciver total amount
  def reciver_amount
    total=0
    recivers.each do |r|
      if [9,11].include? doc_type
        next if r.fi_amount==nil
        final_amount=r.fi_amount
      else    #[10,12]
        next if r.amount==nil
        final_amount=r.amount
      end
      total+=final_amount
    end
    total
  end
  #=====================================================
  #获得所有的审批流程
  def work_flow_steps
    which_duty = (real_person==nil ? person.duty : real_person.duty)
    wf=WorkFlow.all.select{|w| w.doc_types.split(';').include? doc_type.to_s and w.duties.include? which_duty }
    return nil if wf.count==0
    wf==nil ? []:wf.first.work_flow_steps.to_a
  end
  #the specific person if there are more than one person ,check the approver_id
  def approver(work_flow_step)
    #logger=Logger.new("wf.txt")
    #logger.info "current work flow step is #{work_flow_step}"
    return nil if work_flow_step==nil
    #put the person back if you find only one person
    if work_flow_step.is_self_dep==0
      persons=Person.where("dep_id=? and duty_id=?",work_flow_step.dep_id,work_flow_step.duty_id)
      return persons.first
    end
    #begin to find the right person
    persons=nil
    dep_to_find=nil
    #decide the dep to look for
    if work_flow_step.work_flow and work_flow_step.work_flow.work_flow_steps.first.duty.code=="003"
      return nil if selected_approver_id==nil
      approver_person=Person.find_by_id(self.selected_approver_id)
      return nil if approver_person==nil
      dep_to_find=approver_person.dep
    else
      if real_person
        dep_to_find=self.real_person.dep
      else
        dep_to_find=self.person.dep
      end
    end
    #if current you find  the part member then return approver_person directly
    return approver_person if work_flow_step.duty.code=='003'
    #ok now we start to find that person
    while dep_to_find
      persons=Person.where("dep_id=? and duty_id=?",dep_to_find.id,work_flow_step.duty_id)
      break if persons.count>0
      dep_to_find=dep_to_find.parent_dep
    end
    #here we must find a person
    persons.first
  end

  #============================current api to get approver info=================================
  #begin to approver
  #decide the people which this doc should be handled to 
  #set approvers
  #set current_approver_id
  def begin_approve(selected_approver)
    #set selected approver
    self.selected_approver_id = selected_approver
    #get this doc's work flow steps
    wfs = work_flow_steps
    approver_ids=[]
    if wfs
      #iterate the workflow
      wfs.each do |wf_step|
        ap = approver(wf_step)
        if ap
          approver_ids << ap.id 
        else 
          approver_ids=nil #this should not happen
          return #no approvers and no current approver
        end
      end
    end
    #now i get all approver ids
    self.approvers = approver_ids.join(',')
    #set the current approver
    self.current_approver_id = approver_ids.first
    #set doc state
    self.doc_state = 1
  end
  #approve
  def approve
    approvers_array = approvers.split(',')
    current_index = approvers_array.index current_approver_id.to_s
    if current_index < approvers_array.count-1
      self.current_approver_id = approvers_array[current_index+1].to_i
    else
      self.doc_state = 2
      self.current_approver_id = -2
    end
  end
  #decline
  def decline
    #终止单据
    self.doc_state=0
  end
  #uploads 
  def uploads
    UploadFile.find_by_doc_no(self.doc_no)
  end
  #==================================about filter================================

  #the budget fee
  def budget_fee_id
    if doc_type==9
      #差旅费
      Fee.find_by_code('03').id
    elsif doc_type==10
      #交际费用
      Fee.find_by_code('02').id
    elsif doc_type==11
      #加班费用
      Fee.find_by_code('06').id      
    elsif doc_type==13
      Fee.find_by_code('04').id
    else
      #其他
      -1
    end
  end
  def self.custom_select(results,column_name,filter_text)
  	if column_name=="doc_state"
    	results.select {|doc| doc.custom_display.include? filter_text}
	  else
		  results
	  end
  end
  #can delete depands on two things
  def can_delete
    can=true
    can=false if reim_cp_offsets.count>0
    can=false if cp_docs.count>0
    can=false if doc_state!=0
    can
  end

  def person_dep
    person.dep.name
  end

  def doc_type_name
    DOC_TYPES[doc_type]
  end
  def doc_state_name
    Doc_State[doc_state]
  end
  #callbacks
  def before_save
    #update the total_fi_amount
    self.total_amount = total_fi_amount
  end
  #判断是否单据已经生成过凭证
  def exist_vouch?
    exist_info=nil
    begin
      exist_info=U8service::API.exist_vouch doc_no
    rescue Exception=>msg
      Rails.logger.error "u8 service exist vouch error ,error msg is #{msg}"
      return false
    end
    return exist_info["Exist"]
  end
  #vouch infos
  #this is a massive method which contains a lot of logic 
  #and 'if else'
  def rg_vouches
    #分摊的逻辑
    if is_split==1 and [9,11,13].include? doc_type
      #加班和差旅基本相同，只是默认的科目不同
      self.vouches.clear
      fee_code_match=nil
      if doc_type==9
        fee_code_match=FeeCodeMatch.find_by_fee_code("03")
      end
      if doc_type==11
        fee_code_match=FeeCodeMatch.find_by_fee_code("06")
      end
      if doc_type==13
        fee_code_match=FeeCodeMatch.find_by_fee_code("04")
        b_fee_code_match=fee_code_match #point to default
      end
      init_count=1
      benefits_codes=[]
      #n debit
      reim_split_details.each do |s|
        #如果是福利费用再变化一次科目，并记录
        fcm=fee_code_match
        if doc_type==13 and s.fee
          b_fee_code_match=FeeCodeMatch.find_by_fee_code(s.fee.code)
          if b_fee_code_match
            benefits_codes<<b_fee_code_match.ccode
            fcm=b_fee_code_match
          end
        end
        vj=get_v ({
          :inid=>"#{init_count}",
          :code=>fcm.dcode,# dai kemu
          :md=>s.percent_amount,:md_f=>s.percent_amount,
          :dep=>s.dep,# dep code
          :project=>s.project,#project code
          :ccode_equal=>fcm.ccode.to_s,
          :s_cdept_id=>fcm.ddep,
          :doc_no=>cdigest_info(fcm),
          :s_cperson_id=>fcm.dperson})
        self.vouches.create(vj)
        init_count=init_count+1
      end
      #1 credit
      vd=get_v ({
        :inid=>"#{init_count}",
        :code=>fee_code_match.ccode,# dai kemu
        :mc=>total_amount,:mc_f=>total_amount,
        :dep=>nil,# dep code
        :project=>nil,#project code
        :s_cdept_id=>fee_code_match.cdep,
        :doc_no=>cdigest_info(fee_code_match),
        :s_cperson_id=>fee_code_match.cperson,
        :ccode_equal=>(doc_type==13 ? benefits_codes.join(",") : fee_code_match.ccode.to_s)})
      self.vouches.create(vd)
    else
      #借款或付款单据【只生成一个借和一个贷，】
      ###################################################################################################
      if doc_type==1 or doc_type==2
        #get the two code
        if doc_type==1
          fee_m_code=FeeCodeMatch.find_by_fee_code("07") 
        else
          fee_m_code=FeeCodeMatch.find_by_fee_code("08")
        end
        self.vouches.clear
        #n条借方
        jcount=1
        self.cp_doc_details.each do |cp|
           vj=get_v ({:inid=>"#{jcount}",
           :code=>fee_m_code.dcode,
           :md=>total_amount,:md_f=>total_amount,
           :dep=>cp.dep,
           :project=>cp.project,
           :doc_no=>cdigest_info(fee_m_code),
           :s_cdept_id=>fee_m_code.ddep,
           :s_cperson_id=>fee_m_code.dperson,
           :ccode_equal=>fee_m_code.ccode.to_s})
          self.vouches.create(vj)
          jcount+=1
        end
        #1个贷方
        vd=get_v ({
          :inid=>"#{jcount}",
          :code=>fee_m_code.ccode,# dai kemu
          :md=>"0",:mc=>total_amount,:mc_f=>total_amount,
          :dep=>nil,# dep code
          :project=>nil,#project code
          :s_cdept_id=>fee_m_code.cdep,
          :doc_no=>cdigest_info(fee_m_code),
          :s_cperson_id=>fee_m_code.cperson,
          :ccode_equal=>fee_m_code.dcode.to_s})
        self.vouches.create(vd)
      end
      #差旅费用【只生成一个借和一个贷，】
      ###################################################################################################
      if doc_type==9
        #get the two code
        fee_m_code=FeeCodeMatch.find_by_fee_code("03")
        vj=get_v ({:inid=>"1",
          :code=>fee_m_code.dcode,
          :md=>total_amount,:md_f=>total_amount,
          :dep=>afford_dep,
          :project=>project,
          :person=>nil,
          :doc_no=>cdigest_info(fee_m_code),
          :s_cdept_id=>fee_m_code.ddep,
          :s_cperson_id=>fee_m_code.dperson,
          :ccode_equal=>fee_m_code.ccode.to_s})
        vd=get_v ({
          :inid=>"2",
          :code=>fee_m_code.ccode,# dai kemu
          :md=>"0",:mc=>total_amount,:mc_f=>total_amount,
          :dep=>afford_dep,# dep code
          :project=>project,#project code
          :s_cdept_id=>fee_m_code.cdep,
          :doc_no=>cdigest_info(fee_m_code),
          :s_cperson_id=>fee_m_code.cperson,
          :ccode_equal=>fee_m_code.dcode.to_s})
        self.vouches.clear
        self.vouches.create(vj)
        self.vouches.create(vd)
      end
      #交际费用，没有分摊，每个明细都是一条借(已经对相同的项目和部门的分录进行了合并)
      ###################################################################################################
      if doc_type==10
        self.vouches.clear
        fee_m_code=FeeCodeMatch.find_by_fee_code("02")
        init_count=1
        #n 条借
        #根据新的需求，如果有部门项目相同的则进行合并，所以部门加项目是唯一的key
        combined_wms={} #先把合并后的放进这个结构，然后再进行凭证生成
        #这个结构为 key=>"#{project_id}__#{dep_id}",:value=>{:project=>project,:dep=>dep,:amount=>....}
        rd_work_meals.each do |w_m|
          key="#{w_m.project_id}__#{w_m.dep_id}"
          if combined_wms.include? key
            combined_wms[key][:amount]+=w_m.apply_amount
          else
            combined_wms[key]={:project=>w_m.project,:dep=>w_m.dep,:amount=>w_m.amount }
          end
        end
        #这里才进行真正的生成
        combined_wms.each do |k,c_w_m|
          vj=get_v ({
            :inid=>"#{init_count}",
            :code=>fee_m_code.dcode,# dai kemu
            :md=>c_w_m[:amount],:md_f=>c_w_m[:amount],
            :dep=>c_w_m[:dep],# dep code
            :project=>c_w_m[:project],#project code
            :person=>nil,
            :doc_no=>cdigest_info(fee_m_code),
            :s_cdept_id=>fee_m_code.ddep,
            :s_cperson_id=>fee_m_code.dperson,
            :ccode_equal=>fee_m_code.ccode.to_s})
          self.vouches.create(vj)
          init_count=init_count+1
        end
        #一条贷
        vd=get_v ({
          :inid=>"#{init_count}",
          :code=>fee_m_code.ccode,# dai kemu
          :mc=>total_amount,:mc_f=>total_amount,
          :dep=>nil,# dep code should select
          :project=>nil,#project code should select
          :s_cdept_id=>fee_m_code.cdep,
          :doc_no=>cdigest_info(fee_m_code),
          :s_cperson_id=>fee_m_code.cperson,
          :ccode_equal=>fee_m_code.dcode.to_s})
        self.vouches.create(vd)
      end
      #加班费用，一个贷，两个借
      ###################################################################################################
      if doc_type==11
        self.vouches.clear
        fee_m_code_meal=FeeCodeMatch.find_by_fee_code("0601")
        fee_m_code_car=FeeCodeMatch.find_by_fee_code("0602")
        jb_fcms=[]
        #1个或2个借
        inid_count=1
        if rd_extra_work_meals.count>0
          jb_fcms<<fee_m_code_meal
          total=0
          rd_extra_work_meals.each {|w_m| total=w_m.fi_amount+total}
          vj=get_v ({
            :inid=>"#{inid_count}",
            :code=>fee_m_code_meal.dcode,# dai kemu
            :md=>total,:md_f=>total,
            :dep=>afford_dep,# dep code
            :project=>project,#project code
            :person=>nil,
            :doc_no=>cdigest_info(fee_m_code_meal),
            :s_cdept_id=>fee_m_code_meal.ddep,
            :s_cperson_id=>fee_m_code_meal.dperson,
            :ccode_equal=>fee_m_code_meal.ccode.to_s})
          self.vouches.create(vj)
          inid_count=inid_count+1
        end
        if rd_extra_work_cars.count>0
          jb_fcms<<fee_m_code_car
          total=0
          rd_extra_work_cars.each {|w_c| total=w_c.fi_amount+total}
          vj=get_v ({
            :inid=>"#{inid_count}",
            :code=>fee_m_code_car.dcode,# dai kemu
            :md=>total,:md_f=>total,
            :dep=>afford_dep,# dep code
            :project=>project,#project code
            :person=>nil,
            :doc_no=>cdigest_info(fee_m_code_car),
            :s_cdept_id=>fee_m_code_car.ddep,
            :s_cperson_id=>fee_m_code_car.dperson,
            :ccode_equal=>fee_m_code_car.ccode.to_s})
          self.vouches.create(vj)
          inid_count=inid_count+1
        end
        #一条贷
        vd=get_v ({
          :inid=>"#{inid_count}",
          :code=>fee_m_code_meal.ccode,# dai kemu
          :mc=>total_amount,:mc_f=>total_amount,
          :dep=>nil,# dep code should select
          :project=>nil,#project code should select
          :s_cdept_id=>fee_m_code_meal.cdep,
          :doc_no=>cdigest_info(jb_fcms),
          :s_cperson_id=>fee_m_code_meal.cperson,
          :ccode_equal=>fee_m_code_meal.dcode.to_s})
        self.vouches.create(vd)
      end
      #福利费用(已经根据fee project和dep进行了合并)
      ###################################################################################################
      if doc_type==13
        self.vouches.clear
        vd_codes=[]
        fee_m_code=FeeCodeMatch.find_by_fee_code("04")
        fl_fcms=[]
        #n条借方
        #cobined hash
        combined_benefits={}
        rd_benefits.each do |b|
          #get fee code info
          if b.fee
            fee_m_code=FeeCodeMatch.find_by_fee_code(b.fee.code)
            fl_fcms<<fee_m_code if !fl_fcms.include? fee_m_code
          end
          vd_codes<<fee_m_code.dcode.to_s
          #到这里的时候已经确定了fee，用fee+dep+project作为key进行合并
          combine_key="#{fee_m_code.id}__#{b.dep.id}__#{b.project.id}"
          if combined_benefits[combine_key]
            combined_benefits[combine_key][:amount]+=b.fi_amount
          else
            combined_benefits[combine_key]={:dep=>b.dep,:project=>b.project,:amount=>b.fi_amount,:fee=>fee_m_code}
          end
        end
        #这里进行真正的生成
        inid_count=1
        combined_benefits.each do |k,b|
          vj=get_v ({
            :inid=>"#{inid_count}",
            :code=>b[:fee].dcode,# dai kemu
            :md=>b[:amount],:md_f=>b[:amount],
            :dep=>b[:dep],# dep code
            :project=>b[:project],#project code
            :person=>nil,
            :doc_no=>cdigest_info(b[:fee]),
            :s_cdept_id=>b[:fee].ddep,
            :s_cperson_id=>b[:fee].dperson,
            :ccode_equal=>b[:fee].ccode.to_s})
          self.vouches.create(vj)
          inid_count=inid_count+1
        end
        #一条贷
        vd=get_v ({
          :inid=>"#{inid_count}",
          :code=>fee_m_code.ccode,# dai kemu
          :mc=>total_amount,:mc_f=>total_amount,
          :dep=>nil,# dep code should select
          :project=>nil,#project code should select
          :s_cdept_id=>fee_m_code.cdep,
          :doc_no=>cdigest_info(fl_fcms),
          :s_cperson_id=>fee_m_code.cperson,
          :ccode_equal=>vd_codes.join(',')})
        self.vouches.create(vd)
      end
      #普通费用
      ###################################################################################################
      if doc_type==12
        self.vouches.clear
        #default fee code match
        fee_m_code=FeeCodeMatch.find_by_fee_code("01")
        inid_count=1
        vd_codes=[]
        fcms=[] #记录可能的费用类型
        #-----------------------------------------------------------------------
        #普通费用n条借
        if common_riems.count>0
          comb_info={}
          fcms<<fee_m_code
          #先进行合并
          common_riems.each do |r|
            #get fee code info
            vd_codes<<fee_m_code.dcode.to_s
            #combine it
            comb_key="#{r.dep.id}__#{r.project.id}"
            if comb_info[comb_key]
              comb_info[comb_key][:amount]+=r.apply_amount
            else
              comb_info[comb_key]={:dep=>r.dep,:project=>r.project,:amount=>r.apply_amount}
            end
          end
          comb_info.each do |k,r|
            vj=get_v ({
              :inid=>"#{inid_count}",
              :code=>fee_m_code.dcode,# dai kemu
              :md=>r[:amount],:md_f=>r[:amount],
              :dep=>r[:dep],# dep code
              :project=>r[:project],#project code
              :person=>nil,
              :doc_no=>cdigest_info(fee_m_code),
              :s_cdept_id=>fee_m_code.ddep,
              :s_cperson_id=>fee_m_code.dperson,
              :ccode_equal=>fee_m_code.ccode.to_s})
            self.vouches.create(vj)
            inid_count=inid_count+1
          end
        end
        #-----------------------------------------------------------------------
        #工作餐费n条借
        if rd_work_meals.count>0
          comb_info={}
          fee_g_code=FeeCodeMatch.find_by_fee_code("0102")
          fcms<<fee_g_code
          rd_work_meals.each do |r|
            #get fee code info
            vd_codes<<fee_g_code.dcode.to_s
            #combine it
            comb_key="#{r.dep.id}__#{r.project.id}"
            if comb_info[comb_key]
              comb_info[comb_key][:amount]+=r.apply_amount
            else
              comb_info[comb_key]={:dep=>r.dep,:project=>r.project,:amount=>r.apply_amount}
            end
          end
          comb_info.each do |k,r|
            vj=get_v ({
              :inid=>"#{inid_count}",
              :code=>fee_g_code.dcode,# dai kemu
              :md=>r[:amount],:md_f=>r[:amount],
              :dep=>r[:dep],# dep code
              :project=>r[:project],#project code
              :person=>nil,
              :doc_no=>cdigest_info(fee_g_code),
              :s_cdept_id=>fee_g_code.ddep,
              :s_cperson_id=>fee_g_code.dperson,
              :ccode_equal=>fee_g_code.ccode.to_s})
            self.vouches.create(vj)
            inid_count=inid_count+1
          end
        end
        #-----------------------------------------------------------------------
        #业务交通费用n条借
        if rd_common_transports.count>0
          comb_info={}
          fee_y_code=FeeCodeMatch.find_by_fee_code("0103")
          fcms<<fee_y_code
          rd_common_transports.each do |r|
            #get fee code info
            vd_codes<<fee_y_code.dcode.to_s
            #combine it
            comb_key="#{r.dep.id}__#{r.project.id}"
            if comb_info[comb_key]
              comb_info[comb_key][:amount]+=r.apply_amount
            else
              comb_info[comb_key]={:dep=>r.dep,:project=>r.project,:amount=>r.apply_amount}
            end
          end
          comb_info.each do |k,r|
            vj=get_v ({
              :inid=>"#{inid_count}",
              :code=>fee_y_code.dcode,# dai kemu
              :md=>r[:amount],:md_f=>r[:amount],
              :dep=>r[:dep],# dep code
              :project=>r[:project],#project code
              :person=>nil,
              :doc_no=>cdigest_info(fee_y_code),
              :s_cdept_id=>fee_y_code.ddep,
              :s_cperson_id=>fee_y_code.dperson,
              :ccode_equal=>fee_y_code.ccode.to_s})
            self.vouches.create(vj)
            inid_count=inid_count+1
          end
        end
        #1条贷
        vd=get_v ({
          :inid=>"#{inid_count}",
          :code=>fee_m_code.ccode,# dai kemu
          :mc=>total_amount,:mc_f=>total_amount,
          :dep=>nil,# dep code should select
          :project=>nil,#project code should select
          :s_cdept_id=>fee_m_code.cdep,
          :doc_no=>cdigest_info(fcms),
          :s_cperson_id=>fee_m_code.cperson,
          :ccode_equal=>vd_codes.join(',')})
        self.vouches.create(vd)
      end
    end
  end
  private
  def cdigest_info(fee_code_match)
    cdigest_info=""
    cdigest_info<<"#{person.name},"
    if fee_code_match.is_a? Array
      fee_code_match.each do |fcm|
        cdigest_info<<"#{fcm.fee.name},"
      end
    else
      cdigest_info<<"#{fee_code_match.fee.name}"
    end
    cdigest_info<<"[#{doc_no}]"
    return cdigest_info
  end
  def get_v(options)
    #get current max vouch no and plus 1 as current vouch no
    vouch_no="test in dev"
    if RAILS_ENV=="production"
      vouch_no=U8service::API.max_vouch_info(Time.now.month)["MaxNo"].to_i + 1
    end
    #the time
    time="#{Time.now.year}-#{Time.now.month}-#{Time.now.day}"
    #default options
    #get the default from system config
    config_cbill=SystemConfig.find_by_key("cbill")
    default_opt={
      :ino_id=>"#{vouch_no}",:inid=>"1",:dbill_date=>time,
      :idoc=>"0",:cbill=>(config_cbill ? config_cbill.value : "OES"),:doc_no=>"#{person.name},#{doc_type_name}[#{doc_no}]",
      :ccode=>"",# dai kemu
      :cexch_name=>"人民币",#currency name
      :md=>"0",:mc=>"0",:md_f=>"0",:mc_f=>"0",
      :nfrat=>"1",# currency rate
      :cdept_id=>"00001",# dep code should select
      :person=>person,#person code
      :citem_id=>"",#project code should select
      :ccode_equal=>""}
    default_opt.merge! options
  end
end
