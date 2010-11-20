#coding: utf-8
class DocHead < ActiveRecord::Base
  belongs_to :fee
  belongs_to :dep
  belongs_to :person
  belongs_to :currency
  belongs_to :afford_dep, :class_name => "Dep", :foreign_key => "afford_dep_id"
  belongs_to :upload_file
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
  has_many :other_riems, :class_name => "OtherRiem", :foreign_key => "doc_head_id",:dependent=>:destroy
  #warn 这里最好不要都reject,因为reject的根本就不会进行校验，而且不会爆出任何错误信息
  accepts_nested_attributes_for :reim_split_details ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_extra_work_meals ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_benefits ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_common_transports ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_extra_work_cars ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_work_meals ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_lodgings ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_travels ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :rd_transports ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :common_riems ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :other_riems ,:reject_if => lambda { |a| a[:sequence].blank? }, :allow_destroy => true

  #the great offset info here
  has_many :reim_cp_offsets,:class_name => "RiemCpOffset",:foreign_key=>"reim_doc_head_id",:dependent=>:destroy
  has_many :cp_docs,:through=>:reim_cp_offsets,:source=>:cp_doc_head
  enum_attr :is_split, [['否', 0], ['是', 1]]
  Doc_State={0=>"未提交",1=>"审批中",2=>"审批通过"}
  DOC_TYPES = {1=>"借款单",2=>"付款单",3=>"收款通知单",4=>"结汇",5=>"转账",6=>"现金提取",7=>"购买理财产品",8=>"赎回理财产品",9=>"差旅费报销",10=>"交际费报销",11=>"加班费报销",12=>"普通费用报销",13=>"福利费用报销"}
  #validate the amout is ok
  validate :must_equal,:dep_and_project_not_null,:project_not_null_if_charge
  def project_not_null_if_charge
    errors.add(:base,"收款单明细 项目不能为空") if doc_type==2 and cp_doc_details.size>0 and !cp_doc_details.all? {|c| c.project_id!=nil}
  end
  def must_equal
    errors.add(:base, "报销总金额#{total_apply_amount}，- 冲抵总金额#{offset_amount}，不等于 收款总金额#{reciver_amount}") if total_apply_amount-offset_amount!=reciver_amount and doc_type>=9 and doc_type<=12
    errors.add(:base,"借款总金额#{total_apply_amount} 不等于 收款总金额#{reciver_amount}") if total_apply_amount!=reciver_amount and doc_type<=2
    #the amount of issplit should be equal to total_apply_amount
    errors.add(:base,"分摊总金额#{split_total_amount} 不等于 单据总金额#{total_apply_amount}") if is_split==1 and split_total_amount!=total_apply_amount
  end
  def dep_and_project_not_null
    #debugger
    errors.add(:base,"表头项目或费用承担部门不能为空") if (doc_type==9 or doc_type==11) and is_split==0 and (dep_id==nil or project_id==nil)
  end
  def self.custom_display_columns
  	{"申请金额"=>:total_apply_amount}
  end
  #the total apply amount
  def total_apply_amount
    total=0
    if doc_type==1 or doc_type==2
      cp_doc_details.each do |cp|
        next if cp.apply_amount==nil
        total+=cp.apply_amount
      end
    end
    if doc_type==4
      total=inner_remittance.amount
    end
    if doc_type==5
      total=inner_transfer.amount 
    end
    if doc_type==6
      inner_cash_draw.cash_draw_items.each do |c_item|
        total+=c_item.apply_amount
      end
    end
    if doc_type==7
      total=buy_finance_product.amount
    end
    if doc_type==8
      total=redeem_finance_product.amount
    end
    if doc_type==9
      [rd_travels,rd_transports,rd_lodgings,other_riems].each do |rd|
        rd.each do |rd_detail|
          next if rd_detail.fi_amount==nil
          total+=rd_detail.fi_amount         
        end
      end
    end
    if doc_type==10
      rd_work_meals.each do |rd|
        next if rd.apply_amount==nil
        total+=rd.apply_amount
      end
    end
    if doc_type==11
      [rd_extra_work_cars,rd_extra_work_meals].each do |rd|
        rd.each do |rd_detail|
          next if rd_detail.fi_amount==nil
          total+=rd_detail.fi_amount         
        end
      end
    end
    if doc_type==12
      [rd_common_transports,rd_work_meals,common_riems].each do |rd|
        rd.each do |rd_detail|
          next if rd_detail.apply_amount==nil
          total+=rd_detail.apply_amount
        end
      end
    end
    total
  end
  def split_total_amount
    total=0
    reim_split_details.each do |split|
      total+=split.percent_amount
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
      if [9,11].include? doc_type
        next if r.fi_amount==nil
        final_amount=r.fi_amount
      else    #[10,12]
        next if r.amount==nil
        final_amount=r.amount
      end
      r.direction==0 ? total+=final_amount : total-=final_amount
    end
    total
  end
  #=====================================================
  #获得所有的审批流程
  def work_flows
    wf=WorkFlow.all.select{|w| w.doc_types.split(';').include? doc_type.to_s and w.duties.include? person.duty }
    return nil if wf.count==0
    wf==nil ? []:wf.first.work_flow_steps.to_a
  end
  def current_work_flow_step
    wfs=nil
    if self.work_flow_step_id and self.work_flow_step_id>=0
      wfs=WorkFlowStep.find_by_id(self.work_flow_step_id)
    end
    wfs
  end
  #the specific person if there are more than one person ,check the approver_id
  def approver(work_flow_step=current_work_flow_step)
    return nil if work_flow_step==nil
    persons=nil
    dep_to_find=nil
    #decide the dep to look for
    if work_flow_step.work_flow.work_flow_steps.first.duty.code=="003"
      return nil if approver_id==nil
      approver_person=Person.find_by_id(self.approver_id)
      return nil if approver_person==nil
      dep_to_find=approver_person.dep
    else
      dep_to_find=self.person.dep
    end
    #if current you find  the part member then return approver_person directly
    return approver_person if work_flow_step.duty.code=='003'
    #ok now we start to find that person
    if work_flow_step.is_self_dep==0
      persons=Person.where("dep_id=? and duty_id=?",work_flow_step.dep_id,work_flow_step.duty_id)
    else
      while dep_to_find
        persons=Person.where("dep_id=? and duty_id=?",dep_to_find.id,work_flow_step.duty_id)
        break if persons.count>0
        dep_to_find=dep_to_find.parent_dep
      end
    end
    #here we must find a person
    persons.first
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
  NOT_DISPLAY=['work_flow_step_id','reim_description','is_split','cp_doc_remain_amount','attach','approver_id','dep_id','fee_id','paid','project_id','upload_file_id','note','total_amount']
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
  def can_delete
    return doc_state==0
  end
  #here is the total custom display column names
  def self.my_doc_display_columns
    ["doc_no","person_id","apply_date","doc_type","doc_state","amount"]
  end
  def self.doc_to_approve_display_columns
    #debugger
    ["doc_no","person_id","apply_date","doc_type","amount","doc_state"]
  end
  def self.not_search
    ["is_split","work_flow_step_id","reim_description",'approver_id',"cp_doc_remain_amount",'person_id']
  end
  def self.docs_to_approve(result,current_person)
  	result=result.select {|doc| doc.approver==current_person}
  end
end
