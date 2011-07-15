#coding: utf-8
require "#{Rails.root}/app/u8service/api.rb"
class DocHead < ActiveRecord::Base
  include DocHeadVouch
  belongs_to :dep
  belongs_to :person
  belongs_to :afford_dep, :class_name => "Dep", :foreign_key => "afford_dep_id"
  belongs_to :upload_file
  belongs_to :real_person, :class_name => "Person", :foreign_key => "real_person_id"
  belongs_to :project

  validates_presence_of :doc_no, :on => :create, :message => "单据号必输"
  validates_presence_of :apply_date, :on => :create, :message => "申请日期必须输入"
  validates_uniqueness_of :doc_no, :on => :create, :message => "已经存在相同的单据号"
  validate :must_equal,:dep_and_project_not_null,:project_not_null_if_charge,:dep_is_end
  validate :must_equal,:if => lambda { |doc| doc.processing? }
  #has many recivers and cp_doc_details

  has_one :inner_remittance, :class_name => "InnerRemittance", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_one :inner_transfer, :class_name => "InnerTransfer", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_one :inner_cash_draw, :class_name => "InnerCashDraw", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_one :buy_finance_product, :class_name => "BuyFinanceProduct", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_one :redeem_finance_product, :class_name => "RedeemFinanceProduct", :foreign_key => "doc_head_id",:dependent=>:destroy


  has_many :recivers, :class_name => "Reciver", :foreign_key => "doc_head_id",:dependent => :destroy
  has_many :cp_doc_details, :class_name => "CpDocDetail", :foreign_key => "doc_head_id",:dependent => :destroy
  has_many :rec_notice_details,:class_name=>"RecNoticeDetail",:foreign_key=>"doc_head_id",:dependent=>:destroy
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
  has_many :fixed_properties,:class_name=>"FixedProperty",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :reim_cp_offsets,:class_name => "RiemCpOffset",:foreign_key=>"reim_doc_head_id",:dependent=>:destroy
  has_many :cp_docs,:through=>:reim_cp_offsets,:source=>:cp_doc_head
  has_many :work_flow_infos, :class_name => "WorkFlowInfo", :foreign_key => "doc_head_id",:dependent=>:destroy
  #here is for the vouch info
  has_many :vouches,:class_name=>"Vouch",:foreign_key=>"doc_head_id",:dependent=>:destroy

  #warn 这里最好不要都reject,因为reject的根本就不会进行校验，而且不会爆出任何错误信息
  accepts_nested_attributes_for :recivers, :allow_destroy => true
  accepts_nested_attributes_for :cp_doc_details , :allow_destroy => true
  accepts_nested_attributes_for :rec_notice_details , :allow_destroy => true
  accepts_nested_attributes_for :inner_remittance , :allow_destroy => true
  accepts_nested_attributes_for :inner_transfer , :allow_destroy => true
  accepts_nested_attributes_for :inner_cash_draw , :allow_destroy => true
  accepts_nested_attributes_for :buy_finance_product ,:allow_destroy => true
  accepts_nested_attributes_for :redeem_finance_product , :allow_destroy => true
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
  accepts_nested_attributes_for :fixed_properties ,:allow_destroy => true

  before_save :set_total_amount
  after_initialize :init_doc

  Doc_State={'un_submit'=>"未提交",'processing'=>"审批中",'approved'=>"审批通过",'paid'=>"已付款",'rejected'=>'未通过'}
  DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"交际费报销",11=>"加班费报销",12=>"普通费用报销",13=>"福利费用报销",14=>"固定资产单据"}
  DOC_TYPE_PREFIX={1=>"JK",2=>"FK",3=>"SK",4=>"JH",5=>"ZH",6=>"XJ",7=>"GL",8=>"SL",9=>"BXCL",10=>"BXJJ",11=>"BXJB",12=>"BXFY",13=>"BXFL",14=>"GDZC"}

  def init_doc
    return unless self.new_record?
    self.doc_type = 1 if !doc_type
    #set a number to
    doc_count_config=ConfigHelper.find_by_key(:doc_count) || ConfigHelper.create(:key=>"doc_count",:value=>"0") 
    if doc_count_config.value==5000
      doc_count_config.value="0"
    else
      doc_count_config.value=(doc_count_config.value.to_i+1).to_s
    end
    doc_count_config.save
    self.doc_no=DOC_TYPE_PREFIX[self.doc_type]+Time.now.strftime("%Y%m%d")+doc_count_config.value.rjust(4,"0")
    #set date
    self.apply_date = Time.now
    #set current_approver
    self.current_approver_id = -3
  end

  def approver
    Person.where('id=?',current_approver_id).first
  end

  def project_not_null_if_charge
    errors.add(:base,"收款单明细 项目不能为空") if doc_type==2 and cp_doc_details.size>0 and !cp_doc_details.all? {|c| c.project_id!=nil}
  end
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if (afford_dep and afford_dep.sub_deps.count>0)
  end
  def must_equal
    #errors.add(:base, "报销总金额#{total_fi_amount}，- 冲抵总金额#{offset_amount}，不等于 收款总金额#{reciver_amount}") if total_fi_amount-offset_amount!=reciver_amount and doc_type>=9 and doc_type<=12
    #errors.add(:base,"借款总金额#{total_fi_amount} 不等于 收款总金额#{reciver_amount}") if total_fi_amount!=reciver_amount and doc_type<=2
    ##the amount of issplit should be equal to total_fi_amount
    #errors.add(:base,"分摊总金额#{split_total_amount} 不等于 单据总金额#{total_fi_amount}") if is_split==1 and split_total_amount!=total_fi_amount
  end
  #############################################
  scope :by_person, lambda {|person_id| where("person_id=?",person_id)} 
  def dep_and_project_not_null
    #debugger
    errors.add(:base,"表头项目或费用承担部门不能为空") if (doc_type==9 or doc_type==11) and is_split==0 and (dep_id==nil or project_id==nil)
  end

  #get amount for specific doc type
  #asumme every detail has a amount attribute
  def amount_for(relation_name)
    total=0
    details=self.send(relation_name)
    if details
      #has_many
      if details.is_a? Array
        details.each do |d|
          total+=get_amount(d)
        end
      else
        total=get_amount(details)
      end
    end
    total
  end
  def get_amount(d)
    if d.respond_to? :amount
      d.amount || 0
    elsif d.respond_to? :apply_amount
      d.apply_amount || 0
    elsif d.respond_to? :buy_unit
      d.buy_unit || 0
    elsif d.respond_to? :total_amount
      d.total_amount || 0
    elsif d.respond_to? :percent_amount
      d.percent_amount || 0
    else
      0
    end
  end
  #get doc amount by type ---apply_amount? hr_amount? fi_amount?
  def get_total_apply_amount
    total=0
    if doc_type==1 or doc_type==2
      total+= amount_for :cp_doc_details
    end
    if doc_type==3
      total+= amount_for :rec_notice_details
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
      %w(rd_travels rd_transports rd_lodgings other_riems).each do |rd|
        total+=amount_for rd       
      end
    end
    if doc_type==10
      total+=amount_for :rd_work_meals
    end
    if doc_type==11
      %w(rd_extra_work_cars rd_extra_work_meals).each do |rd|
        total+=amount_for rd
      end
    end
    if doc_type==12
      %w(rd_common_transports rd_work_meals common_riems).each do |rd|
        total+=amount_for rd
      end
    end
    if doc_type==13
      total+= amount_for :rd_benefits
    end
    if doc_type==14
      total+=amount_for :fixed_properties
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
      total+=(r.amount || 0)
    end
    total
  end
  #=====================================================
  #获得所有的审批流程
  def work_flow
    which_duty = (real_person==nil ? person.duty : real_person.duty)
    wf=WorkFlow.all.select{|w| w.doc_meta_infos.map(&:code).include? doc_type.to_s and w.duties.include? which_duty }
    wf.first
  end

  state_machine :state, :initial => :un_submit do
    after_transition [:rejected,:un_submit] => :processing do |doc_head, transition|
      doc_head.set_approvers
    end    
    event :submit do
      transition [:rejected,:un_submit] => :processing
    end
    event :recall do
      transition [:processing] => :un_submit
    end
    event :approve do
      transition [:processing] => :approved
    end
    event :pay do
      transition [:approved] => :paid
    end
    event :reject do
      transition [:processing] => :rejected
    end
  end

  #approve
  def next_approver(comments='OK')
    return unless self.processing?
    approver_array = approvers.split(',')
    current_index = approver_array.index current_approver_id.to_s

    if current_index!=nil
      self.work_flow_infos << WorkFlowInfo.create(:is_ok=>true,:comments=>comments,:approver_id=>current_approver_id) 
      if current_index+1<approver_array.count
        self.update_attribute :current_approver_id,approver_array[current_index+1]
      else
        self.update_attribute :current_approver_id,-520
        self.approve
      end
    else
      self.update_attribute :current_approver_id,-1000
    end
  end

  def set_approvers
    approvers_ids = []
    if (work_flow and work_flow.work_flow_steps.count > 0)
      work_flow.work_flow_steps.each do |w|
        if w.is_self_dep
          dep = person.dep
          while dep do
            p = Person.where("dep_id=? and duty_id=?",dep.id,w.duty_id).first
            if p
              approvers_ids<<p.id
              break
            end
            dep = dep.parent_dep
          end #end while
        else
          p = Person.where("dep_id = ? and duty_id =?",w.dep_id,w.duty_id).first
          if p
            approvers_ids<<p.id
          end
        end #end is self dep
      end #block end
    end
    self.update_attribute :approvers,approvers_ids.join(',')
    self.update_attribute(:current_approver_id,approvers_ids[0]) if approvers_ids.count>0
  end

  #decline
  def decline(comments='')
    #终止单据
    self.work_flow_infos << WorkFlowInfo.create(:is_ok=>false,:comments=>comments,:approver_id=>current_approver_id) 
    self.reject
    self.approvers = nil
    self.current_approver_id = nil
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

  #can delete depands on two things
  def can_destroy? user
    self.un_submit? and user.person==self.person
  end
  def can_edit? user
    (self.un_submit? or self.rejected?) and user.person==self.person
  end

  def approver_persons
    self.approvers.split(',').map { |approver| Person.find_by_id(approver)}
  end

  def person_dep
    person.dep.name
  end

  def doc_type_name
    DOC_TYPES[doc_type]
  end
  def doc_state_name
    Doc_State[state]
  end
  #minus reciver's amount
  def reduce_recivers_amount(amount)
    recivers.first.reduce_amount(amount)
  end
  #callbacks
  def set_total_amount
    #update the total_fi_amount
    self.total_amount = get_total_apply_amount
  end
end
