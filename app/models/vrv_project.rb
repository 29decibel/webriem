#coding: utf-8
class VrvProject < ActiveRecord::Base
  has_paper_trail

  has_one :customer_contact
  has_one :network_condition
  has_many :competitors
  has_many :busi_communications
  has_many :tech_communications
  has_one :product_test
  has_one :bill_prepare
  has_one :contract_predict
  has_one :bill_stage
  has_one :bill_after
  has_many :implement_activities
  belongs_to :person

  has_many :approver_infos
  belongs_to :current_approver_info,:class_name => 'ApproverInfo',:foreign_key => 'current_approver_info_id'
  has_many :work_flow_infos, :class_name => "WorkFlowInfo", :foreign_key => "vrv_project_id",:dependent=>:destroy

  AMOUNT = %w(5万以下 5-10万以下 10-30万以下 30-50万以下 50-100万以下 100万及其以上)
  SOURCE = %w(直单 代理)
  
  validates :amount,:inclusion => AMOUNT
  validates :source,:inclusion => SOURCE
  validates :customer,:presence=>true,:uniqueness=>true
  validates :customer_industry,:presence=>true
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

  def system_star
    self[:system_star] || 0
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
    # copy attributes
    doc.contract_doc.source = self.source
    doc.contract_doc.customer = self.customer
    doc.contract_doc.email = self.email
    doc.contract_doc.work_phone = self.phone
    doc.contract_doc.channel = self.channel
    doc.apply_date = Time.now
    doc.save
    logger.info doc.errors.full_messages
    doc
  end

  def star
    human_star || system_star
  end
  #未提交，审核中，星级状态，中标状态，未中标状态，报废
  state_machine :state, :initial => :un_submit do
    after_transition [:processing] => :star do |project,transition|
      project.update_attribute :system_star,1
    end
    after_transition [:rejected,:un_submit] => :processing do |vrv_project, transition|
      vrv_project.set_approvers
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
    wf=WorkFlow.project.all.select{|w| w.duties.include? person.duty }
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
      current_num = VrvProject.where('year(created_at)=?',Time.now.year).count
      self.code = "XM#{Time.now.year}#{(current_num+1).to_s.rjust(5,'0')}"
    end
  end

end
