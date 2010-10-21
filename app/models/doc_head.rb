#coding: utf-8
class DocHead < ActiveRecord::Base
  belongs_to :fee
  belongs_to :dep
  belongs_to :person
  belongs_to :currency
  blongs_to_name_attr :fee
  blongs_to_name_attr :dep
  blongs_to_name_attr :person
  blongs_to_name_attr :project
  blongs_to_name_attr :currency
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
  accepts_nested_attributes_for :recivers,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :cp_doc_details ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rec_notice_details ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
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
  accepts_nested_attributes_for :reim_split_details ,:reject_if => lambda { |a| a[:dep_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_extra_work_meals ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_benefits ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_common_transports ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_extra_work_cars ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_work_meals ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_lodgings ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_travels ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_transports ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  #the great offset info here
  has_many :reim_cp_offsets,:class_name => "RiemCpOffset",:foreign_key=>"reim_doc_head_id",:dependent=>:destroy
  has_many :cp_docs,:through=>:reim_cp_offsets,:source=>:cp_doc_head
  enum_attr :is_split, [['否', 0], ['是', 1]]
  #validate the amout is ok
  validate :must_equal
  def must_equal
    errors.add(:base, "报销总金额#{total_apply_amount}，- 冲抵总金额#{offset_amount}，不等于 收款总金额#{reciver_amount}") if total_apply_amount-offset_amount!=reciver_amount and doc_type>=9 and doc_type<=12
    errors.add(:base,"借款总金额#{total_apply_amount} 不等于 收款总金额#{reciver_amount}") if total_apply_amount!=reciver_amount and doc_type<=2
  end
  #the total apply amount
  def total_apply_amount
    total=0
    if doc_type==1 or doc_type==2
      cp_doc_details.each do |cp|
        total+=cp.apply_amount
      end
    end
    if doc_type==9
      [rd_travels,rd_transports,rd_lodgings].each do |rd|
        rd.each do |rd_detail|
          total+=rd_detail.fi_amount         
        end
      end
    end
    if doc_type==10
      rd_work_meals.each do |rd|
        total+=rd.fi_amount
      end
    end
    if doc_type==11
      [rd_extra_work_cars,rd_extra_work_meals].each do |rd|
        rd.each do |rd_detail|
          total+=rd_detail.fi_amount         
        end
      end
    end
    if doc_type==12
      rd_common_transports.each do |rd|
        total+=rd.fi_amount
      end
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
  #reciver total amount
  def reciver_amount
    total=0
    recivers.each do |r|
      r.direction==0 ? total+=r.amount : total-=r.amount
    end
    total
  end
  #=====================================================
  #pages
  cattr_reader :per_page
  @@per_page = 5
  #校验单据必须有一个单体
  def before_save
    errors.add(:base,"aaa")
  end
  #获得所有的审批流程
  def work_flows
    wf=WorkFlow.all.select{|w| w.doc_types.split(';').include? doc_type.to_s }
    return nil if wf.count==0
    wf==nil ? []:wf.first.work_flow_steps.to_a
  end
  def current_work_flow_step
    wfs=nil
    if self.work_flow_step_id and self.work_flow_step_id>=0
      wfs=WorkFlowStep.find(self.work_flow_step_id)
    end
    wfs
  end
  #这个step对应的那个人是谁
  def approver(work_flow_step=current_work_flow_step)
    person=nil
    return nil if work_flow_step == nil
    #不是本部门的直接找
    if work_flow_step.is_self_dep==0
      person=Person.where("dep_id=? and duty_id=?",work_flow_step.dep_id,work_flow_step.duty_id).first
    else
      return nil if self.person==nil
      dep=self.person.dep
      while dep
        person=Person.where("dep_id=? and duty_id=?",dep.id,work_flow_step.duty_id).first
        break if person
        dep=dep.parent_dep
      end
    end
    person
  end
  #next step
  def next_work_flow_step
    wfs=nil
    if self.doc_state==0
      self.work_flow_step_id=work_flows[0].id
      self.doc_state=1
    elsif self.doc_state==2
      nil
    elsif current_work_flow_step && work_flows
      current_index=work_flows.index(current_work_flow_step)
      if current_index<work_flows.count-1
        wfs=work_flows[current_index+1]
        self.work_flow_step_id=wfs.id
      else
        self.doc_state=2
        self.work_flow_step_id=-1
      end
    end
  end
  #decline
  def decline
    #终止单据
    self.doc_state=0
    self.work_flow_step_id=-1
  end
  #==================================about filter================================
  NOT_DISPLAY=['work_flow_step_id','reim_description','is_split']
  def self.not_display
    NOT_DISPLAY
  end
  CUSTOM_QUERY={
      'person_id'=>{:include=>:person,:conditions=>'people.name like ?'},
      'fee_id'=>{:include=>:fee,:conditions=>'fees.name like ?'},
      'dep_id'=>{:include=>:dep,:conditions=>'deps.name like ?'},
      'project_id'=>{:include=>:project,:conditions=>'projects.name like ?'},
      'currency_id'=>{:include=>:currency,:conditions=>'currencies.name like ?'},
  }
  def self.custom_query(column_name,filter_text)
    if CUSTOM_QUERY.has_key? column_name
      CUSTOM_QUERY[column_name]
    else
      nil
    end
  end
end
