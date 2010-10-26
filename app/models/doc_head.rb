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
  has_many :common_riems, :class_name => "CommonRiem", :foreign_key => "doc_head_id",:dependent=>:destroy
  accepts_nested_attributes_for :reim_split_details ,:reject_if => lambda { |a| a[:dep_id].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_extra_work_meals ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_benefits ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_common_transports ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_extra_work_cars ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_work_meals ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_lodgings ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_travels ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_transports ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :common_riems ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  #the great offset info here
  has_many :reim_cp_offsets,:class_name => "RiemCpOffset",:foreign_key=>"reim_doc_head_id",:dependent=>:destroy
  has_many :cp_docs,:through=>:reim_cp_offsets,:source=>:cp_doc_head
  enum_attr :is_split, [['否', 0], ['是', 1]]
  Doc_State={0=>"未提交",1=>"审批中",2=>"审批通过"}
  DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"工作餐费报销",11=>"加班费报销",12=>"业务交通费报销",13=>"福利费用报销"}
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
  def available_offset_cp_docs(current_person_id)
    cp_offset_docs=DocHead.where("person_id=? and doc_type=1 and cp_doc_remain_amount>0 and doc_state=2 and paid=1",current_person_id).all
    (cp_offset_docs+cp_docs.all).uniq
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
  #may be one more person get back
  def approvers(work_flow_step=current_work_flow_step)
    persons=nil
    return nil if work_flow_step == nil
    #不是本部门的直接找
    if work_flow_step.is_self_dep==0
      persons=Person.where("dep_id=? and duty_id=?",work_flow_step.dep_id,work_flow_step.duty_id)
    else
      return nil if self.person==nil
      dep=self.person.dep
      while dep
        persons=Person.where("dep_id=? and duty_id=?",dep.id,work_flow_step.duty_id)
        break if persons
        dep=dep.parent_dep
      end
    end
    persons
  end
  #the specific person if there are more than one person ,check the approver_id
  def approver(work_flow_step=current_work_flow_step)
    persons=approvers(work_flow_step)
    return nil if persons==nil
    #already apply a approver
    if approver_id and persons.count>1
      ap=persons.select {|p| p.id==approver_id}
      if ap and ap.count==1
        ap.first
      else
        persons.first
      end
    else
      persons.first
    end
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
  NOT_DISPLAY=['work_flow_step_id','reim_description','is_split','cp_doc_remain_amount','person_id','attach','approver_id']
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
  def custom_display(column)
    column_name=column.class==String ? column:column.name
    if column_name=="doc_state"
      return Doc_State[doc_state]
    end
    if column_name=="doc_type"
      return DOC_TYPES[doc_type]
    end
    if column_name=="paid"
      if paid==1
        "已付款"
      else
        "未支付"
      end
    end
  end
  def self.not_search
    ["is_split","work_flow_step_id","reim_description",'approver_id',"cp_doc_remain_amount",'person_id']
  end
end
