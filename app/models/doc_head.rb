#coding: utf-8
class DocHead < ActiveRecord::Base
  belongs_to :fee
  belongs_to :dep
  belongs_to :person
  blongs_to_name_attr :fee
  blongs_to_name_attr :dep
  blongs_to_name_attr :person
  validates_uniqueness_of :doc_no, :on => :create, :message => "已经存在相同的单据号"
  #has many recivers and cp_doc_details
  has_many :recivers, :class_name => "Reciver", :foreign_key => "doc_head_id",:dependent => :destroy
  #has many c and p doc details
  has_many :cp_doc_details, :class_name => "CpDocDetail", :foreign_key => "doc_head_id",:dependent => :destroy
  #many rec notice details
  has_many :rec_notice_details,:class_name=>"RecNoticeDetail",:foreign_key=>"doc_head_id",:dependent=>:destroy
  #only one reum details
  has_one :reim_detail,:class_name=>"ReimDetail",:foreign_key=>"doc_head_id",:dependent=>:destroy
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
  accepts_nested_attributes_for :reim_detail ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :inner_remittance , :allow_destroy => true
  accepts_nested_attributes_for :inner_transfer , :allow_destroy => true
  accepts_nested_attributes_for :inner_cash_draw , :allow_destroy => true
  accepts_nested_attributes_for :buy_finance_product ,:allow_destroy => true
  accepts_nested_attributes_for :redeem_finance_product , :allow_destroy => true
  #审批流
  accepts_nested_attributes_for :work_flow_infos ,:reject_if => lambda { |a| a[:is_ok].blank? }, :allow_destroy => true
  #pages
  cattr_reader :per_page
  @@per_page = 5
  #校验单据必须有一个单体
  def before_save
    errors.add(:base,"aaa")
  end
  #获得所有的审批流程
  def work_flows
    wf=WorkFlow.where("doc_types like '%?%'",doc_type).first
    wf==nil ? []:wf.work_flow_steps.to_a
  end
  def current_work_flow_step
    wfs=nil
    if self.work_flow_step_id>=0
      wfs=WorkFlowStep.find(self.work_flow_step_id)
    end
    wfs
  end
  #这个step对应的那个人是谁
  def approver(work_flow_step=current_work_flow_step)
    person=nil
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
end
