#coding: utf-8
class VrvProject < ActiveRecord::Base
  has_paper_trail :ignore => [:updated_at, :current_approver_info_id,:current_approver_id,:person_id],:class_name=>'VrvProjectVersion',
    :meta=>{:vrv_project_id=>:id,:person_id=>:person_id,:state=>:state}

  has_one :customer_contact,:dependent=>:destroy
  has_one :network_condition,:dependent=>:destroy
  has_many :competitors,:dependent=>:destroy
  has_many :busi_communications,:dependent=>:destroy
  has_many :tech_communications,:dependent=>:destroy
  has_one :product_test,:dependent=>:destroy
  has_one :bill_prepare,:dependent=>:destroy
  has_one :contract_predict,:dependent=>:destroy
  has_one :bill_stage,:dependent=>:destroy
  has_one :bill_after,:dependent=>:destroy
  has_many :implement_activities,:dependent=>:destroy
  belongs_to :person

  has_many :approver_infos,:dependent=>:destroy
  belongs_to :current_approver_info,:class_name => 'ApproverInfo',:foreign_key => 'current_approver_info_id'
  has_many :work_flow_infos, :class_name => "WorkFlowInfo", :foreign_key => "vrv_project_id",:dependent=>:destroy

  belongs_to :u8_customer
  belongs_to :u8_trade

  AMOUNT = %w(5万以下 5-10万以下 10-30万以下 30-50万以下 50-100万以下 100万及其以上)
  SOURCE = %w(直单 代理)
  
  validates :amount,:inclusion => AMOUNT
  validates :source,:inclusion => SOURCE
  validates :customer,:presence=>true,:uniqueness=>true
  validates :u8_trade_id,:presence=>true
  validates :code,:uniqueness => true
  validates :agent_contact,:presence => true,:if => :agent_way?
  validates_presence_of :place
  validates_presence_of :scale
  validates_presence_of :phone_pre,:phone_sur

  scope :processing, where("state='processing'")

  accepts_nested_attributes_for :customer_contact, :allow_destroy => true
  accepts_nested_attributes_for :network_condition, :allow_destroy => true

  after_initialize :set_has_one
  before_validation :set_code
  before_save :set_current_approver_id
  before_save :set_star

  def system_star
    self[:system_star] || 0
  end

  def star
    self[:star] || human_star || system_star
  end

  #def self.token_filter(q)
  #  VrvProject.where('name like ? or customer like ?',"%#{q}%","%#{q}%")
  #end

  def to_s
    customer
  end

  def agent_way?
    self.source == '代理'
  end

  def website
    self[:website] || 'http://'
  end

  def phone
    "#{phone_pre}-#{phone_sur}"
  end

  def start_date
    self[:start_date] || Time.now.to_date
  end

  def generate_contract_doc
    doc_meta_info = DocMetaInfo.find_by_code 'HT'
    doc = DocHead.new :doc_meta_info=>doc_meta_info
    doc.person = self.person
    doc.build_contract_doc
    # copy attributes 项目信息
    doc.contract_doc.source = self.source
    doc.contract_doc.customer = self.customer
    doc.contract_doc.name = self.customer
    doc.contract_doc.place = self.place
    doc.contract_doc.customer_industry = self.customer_industry
    doc.contract_doc.phone = self.phone
    doc.contract_doc.vrv_project = self
    #中标信息
    if self.bill_after
      doc.contract_doc.product_price = self.bill_after.bill_price
      doc.contract_doc.bill_date = self.bill_after.created_at
      doc.contract_doc.bill_price = self.bill_after.bill_price
    end
    #联系人信息
    doc.contract_doc.contact_person = self.customer_contact.name
    doc.contract_doc.contact_duty = self.customer_contact.duty
    doc.contract_doc.contact_phone = self.customer_contact.phone
    doc.contract_doc.contact_email = self.customer_contact.email
    doc.contract_doc.deploy_info = ContractDoc::DEPLOY_INFO.first
    # 其他信息
    doc.apply_date = Time.now
    doc.save
    logger.info doc.errors.full_messages
    doc
  end


  #未提交，审核中，星级状态，中标状态，未中标状态，报废
  state_machine :state, :initial => :un_submit do
    after_transition [:processing] => :star do |project,transition|
      project.update_attribute(:system_star,1) if project.system_star<1
      # send to u8
      project.send_to_u8
    end
    before_transition [:rejected,:un_submit] => :processing do |vrv_project, transition|
      vrv_project.set_approvers
      vrv_project.errors.add(:base,'无法确定第一个审批人') if !vrv_project.current_approver_id
    end    
    after_transition [:processing] => [:rejected,:un_submit] do |vrv_project,transition|
      vrv_project.approver_infos.delete_all
      vrv_project.current_approver_info = nil
      vrv_project.save
    end

    before_transition [:un_submit,:rejected] => :processing do |project,transition|
      project.errors.add(:base,'项目提交审批之前需要填写网络环境信息') if !project.network_condition
    end

    event :submit do
      transition [:rejected,:un_submit] => :processing
    end
    event :reject do
      transition [:processing] => :rejected
    end
    event :recall do
      transition [:processing] => :un_submit
    end
    event :approve do
      transition [:processing] => :star
    end
    event :win do
      transition [:star] => :bid_success
    end
    event :lost do
      transition [:star] => :bid_fail
    end
    event :disable do
      transition [:star] => :invalide
    end
  end


  def work_flow
    @work_flow ||= find_work_flow
  end

  def find_work_flow
    wf=WorkFlow.project.order('priority desc').all.select{|w| w.match_factors?(person.factors) }
    wf.first   
  end

  #approve
  def next_approver(comments='OK')
    return unless self.processing?
    approver_array = approver_infos
    current_index = approver_array.index current_approver_info

    # TODO should skip the disabled ones
    if current_index!=nil
      self.work_flow_infos << self.work_flow_infos.create(:is_ok=>true,:comments=>comments,:approver_id=>current_approver_id) 
      if current_index+1<approver_array.count
        self.current_approver_info = approver_array[current_index+1]
        self.save
      else
        self.current_approver_info = nil
        self.save
        self.approve
      end
    end
  end

  # 在单据开始审批的时候设置所有审批人员
  # 只有第一个环节当审批人超过一个人的时候允许选择审批人
  # create a bunch of approver infos by every work_flow_step
  #
  def set_approvers(user_selected=nil)
    if (work_flow and work_flow.work_flow_steps.count > 0)
      work_flow.work_flow_steps.each_with_index do |w,index|
        approver_info = approver_infos.build(:work_flow_step => w,:vrv_project => self)
        approver_info.enabled = false if (w.max_amount and self.total_amount < w.max_amount)
        approver_info.save
      end #block end
    end
    if approver_infos.count>0
      self.current_approver_info = approver_infos.first
      self.save
    end
  end

  #decline
  def decline(comments='')
    #终止单据
    self.work_flow_infos << WorkFlowInfo.create(:is_ok=>false,:comments=>comments,:approver_id=>current_approver_id) 
    self.reject
  end

  # i_id       序号              自增长
  # citemcode  项目号
  # citemname  项目名称
  # citemccode 项目分类编码  默认为000
  # bclose     是否结算      默认为 false
  # 总部归属   总部归属      文本
  # 行业       行业          文本
  def send_to_u8
    sql = "insert into fitemss01(citemcode,citemname,citemccode,bclose,总部归属,行业) values(
          '#{self.code}','#{self.name}','#{SystemConfig.value('citemccode')||'000'}',
          '#{SystemConfig.value('bclose')||false}','#{self.office_district}','#{self.u8_trade.try(:name)}')"
    U8Service.exec_sql(sql)
  end

  def exist_in_u8?
    sql = 'select count(*) from fitemss01'
    result = U8Service.exec_sql(sql)
    result.count>0 and result.first['']>0
  end

  private
  def set_has_one
    if !customer_contact
      self.customer_contact = CustomerContact.new
    end
  end

  def set_current_approver_id
    self.current_approver_id = current_approver_info.person_id if current_approver_info
  end

  def set_code
    if !self.code
      current_num = VrvProject.where('year(created_at)=?',Time.now.year).order('created_at').last.code[-5..-1].to_i
      self.code = "XM#{Time.now.year}#{(current_num+1).to_s.rjust(5,'0')}"
    end
  end

  def set_star
    self.star = (human_star || system_star)
  end

end
