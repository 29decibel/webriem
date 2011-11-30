#coding: utf-8
class DocHead < ActiveRecord::Base
  include DocHeadVouch
  belongs_to :dep
  belongs_to :person
  belongs_to :afford_dep, :class_name => "Dep", :foreign_key => "afford_dep_id"
  belongs_to :real_person, :class_name => "Person", :foreign_key => "real_person_id"
  belongs_to :project
  belongs_to :doc_meta_info

  before_save :set_afford_dep,:set_current_approver_id
  before_validation :set_doc_no

  scope :by_person, lambda {|person_id| where("person_id=?",person_id)} 
  scope :processing, where("state='processing'")
  scope :un_submit, where("state='un_submit'")
  scope :approved, where("state='approved'")
  scope :paid, where("state='paid'")

  validates_presence_of :doc_no, :on => :create, :message => "单据号必输"
  validates_presence_of :apply_date, :on => :create, :message => "申请日期必须输入"
  validates_uniqueness_of :doc_no, :on => :create, :message => "已经存在相同的单据号"
  # add validation of association
  #validate :total_amount_can_not_be_zero
  validate :processing_doc_current_info_must_one_candidate

  has_many :approver_infos,:dependent=>:destroy
  belongs_to :current_approver_info,:class_name => 'ApproverInfo',:foreign_key => 'current_approver_info_id'

  has_one :contract_doc,:class_name => 'ContractDoc',:foreign_key => 'doc_head_id'
  accepts_nested_attributes_for :contract_doc , :allow_destroy => true
  has_one :outware_doc_detail,:class_name => 'OutwareDocDetail',:foreign_key => 'doc_head_id'
  accepts_nested_attributes_for :outware_doc_detail , :allow_destroy => true

  has_many :borrow_doc_details, :class_name => "BorrowDocDetail", :foreign_key => "doc_head_id",:dependent => :destroy
  has_many :pay_doc_details, :class_name => "PayDocDetail", :foreign_key => "doc_head_id",:dependent => :destroy
  has_many :rd_travels, :class_name => "RdTravel", :foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_transports, :class_name => "RdTransport", :foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_lodgings, :class_name => "RdLodging",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_work_meals, :class_name => "RdWorkMeal",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_communicates, :class_name => "RdCommunicate",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_extra_work_cars, :class_name => "RdExtraWorkCar",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_extra_work_meals, :class_name => "RdExtraWorkMeal",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_benefits, :class_name => "RdBenefit",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :rd_common_transports, :class_name => "RdCommonTransport",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :reim_split_details, :class_name => "ReimSplitDetail",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :common_riems, :class_name => "CommonRiem", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_many :other_riems, :class_name => "OtherRiem", :foreign_key => "doc_head_id",:dependent=>:destroy
  has_many :contract_items,:class_name => 'ContractItem',:foreign_key => "doc_head_id",:dependent=>:destroy 

  has_many :reim_cp_offsets,:class_name => "RiemCpOffset",:foreign_key=>"reim_doc_head_id",:dependent=>:destroy
  has_many :cp_docs,:through=>:reim_cp_offsets,:source=>:cp_doc_head
  has_many :work_flow_infos, :class_name => "WorkFlowInfo", :foreign_key => "doc_head_id",:dependent=>:destroy
  #here is for the vouch info
  has_many :vouches,:class_name=>"Vouch",:foreign_key=>"doc_head_id",:dependent=>:destroy
  has_many :doc_extras,:class_name => 'DocExtra',:dependent => :destroy
  accepts_nested_attributes_for :doc_extras , :allow_destroy => true

  #warn 这里最好不要都reject,因为reject的根本就不会进行校验，而且不会爆出任何错误信息

  accepts_nested_attributes_for :borrow_doc_details , :allow_destroy => true
  accepts_nested_attributes_for :pay_doc_details , :allow_destroy => true
  accepts_nested_attributes_for :reim_split_details , :allow_destroy => true
  accepts_nested_attributes_for :rd_extra_work_meals , :allow_destroy => true
  accepts_nested_attributes_for :rd_benefits , :allow_destroy => true
  accepts_nested_attributes_for :rd_common_transports , :allow_destroy => true
  accepts_nested_attributes_for :rd_extra_work_cars , :allow_destroy => true
  accepts_nested_attributes_for :rd_work_meals , :allow_destroy => true
  accepts_nested_attributes_for :rd_communicates , :allow_destroy => true
  accepts_nested_attributes_for :rd_lodgings , :allow_destroy => true
  accepts_nested_attributes_for :rd_travels , :allow_destroy => true
  accepts_nested_attributes_for :rd_transports , :allow_destroy => true
  accepts_nested_attributes_for :common_riems , :allow_destroy => true
  accepts_nested_attributes_for :other_riems , :allow_destroy => true
  accepts_nested_attributes_for :contract_items , :allow_destroy => true


  Doc_State = ['un_submit','processing','approved','paid','rejected']
  # combine doc_type to doc_type_prefix
  def name
    doc_no
  end

  def apply_date
    self[:apply_date] || Time.now
  end

  def approver
    current_approver_info.person if current_approver_info
  end

  #############################################

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
    # mark_for_destroy check
    if d.respond_to? :apply_amount
      d.apply_amount || 0
    elsif d.respond_to? :amount
      d.amount || 0
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
  def total_apply_amount
    get_total_amount {|resource| resource.respond_to?(:apply_amount) ? resource.apply_amount : 0}
  end

  def final_amount
    get_total_amount {|resource| DocAmountChange.final_amount(resource)}
  end

  def get_total_amount(&block)
    total = 0
    doc_meta_info.doc_relations.multi(true).map(&:doc_row_meta_info).compact.reject{|a|%w(ReimSplitDetail).include? a.name}.each do |dr_meta|
      dr_datas = self.send(eval(dr_meta.name).table_name)
      total += dr_datas.inject(0){|sum,dr_data|sum + block.call(dr_data)}
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

  def self.read_only_attr?(attr)
    %w(doc_no person_id total_amount).include?(attr)
  end
  #=====================================================
  #获得所有的审批流程
  def work_flow
    @work_flow ||= find_work_flow
  end

  def find_work_flow
    p = real_person || person
    wf=WorkFlow.oes.order('priority desc').all.select{|w| w.doc_meta_infos.include? self.doc_meta_info and w.match_factors?(p.factors) }
    wf.first   
  end

  state_machine :state, :initial => :un_submit do
    before_transition [:rejected,:un_submit] => :processing do |doc_head, transition|
      Rails.logger.info '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
      doc_head.set_approvers
      doc_head.current_approver_info
      doc_head.errors.add(:base,'无法确定第一个审批人') if !doc_head.current_approver_id
      Rails.logger.info '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'
    end

    after_transition [:rejected,:un_submit] => :processing do |doc_head, transition|
      doc_head.index_doc_rows
    end

    after_transition [:processing] => [:un_submit,:rejected] do |doc_head,transition|
      doc_head.approver_infos.delete_all
      doc_head.current_approver_info = nil
      doc_head.save
    end

    after_transition [:processing] => [:approved] do |doc_head,transition|
      doc_head.send_ht_to_u8
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

  def index_doc_rows
    doc_meta_info.doc_relations.multi(true).map(&:doc_row_meta_info).compact.reject{|a|%w(ReimSplitDetail).include? a.name}.each do |dr_meta|
      dr_datas = self.send(eval(dr_meta.name).table_name)
      dr_datas.each {|dr| dr.index_doc_row if dr.respond_to?(:index_doc_row)}
    end
  end

  # put after state transi
  after_save  :index_doc_rows

  #approve
  def next_approver(comments='OK')
    return unless self.processing?
    approver_array = approver_infos
    current_index = approver_array.index current_approver_info

    # TODO should skip the disabled ones
    if current_index!=nil
      self.work_flow_infos << WorkFlowInfo.create(:is_ok=>true,:comments=>comments,:approver_id=>current_approver_id) 
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

  # create a bunch of approver infos by every work_flow_step
  def set_approvers(user_selected=nil)
    if (work_flow and work_flow.work_flow_steps.count > 0)
      work_flow.work_flow_steps.each_with_index do |w,index|
        approver_info = approver_infos.build(:work_flow_step => w,:doc_head => self)
        approver_info.enabled = false if (w.max_amount and self.total_amount < w.max_amount)
        approver_info.save
        Rails.logger.info approver_info
      end #block end
    end
    Rails.logger.info approver_infos.count
    if approver_infos.count>0
      Rails.logger.info '!!!!!!!!!!!!!!!!!!!!!'
      self.current_approver_info = approver_infos.first
      self.save
      Rails.logger.info self.errors.full_messages
    end
  end

  def test_approver_infos
    if (work_flow and work_flow.work_flow_steps.count > 0)
      work_flow.work_flow_steps.map {|w| approver_info = approver_infos.build(:work_flow_step => w,:doc_head => self)}
    end
  end

  #decline
  def decline(comments='')
    #终止单据
    self.work_flow_infos << WorkFlowInfo.create(:is_ok=>false,:comments=>comments,:approver_id=>current_approver_id) 
    self.reject
  end

  #citemcode  销售合同号
  #citemname  合同名称
  #citemccode 项目分类编码  默认为000
  #bclose     是否结算      默认为 false
  #对应立项号 对应立项号      文本--插入合同审批表中的项目立项号
  def send_ht_to_u8
    return if self.doc_meta_info.code!='HT'
    # insert into first table
    sql = "insert into fitemss00(citemcode,citemname,citemccode,bclose,对应立项号)
          values('#{self.doc_no}','#{self.contract_doc.name}','#{'000'}','#{false}','#{self.contract_doc.vrv_project.try(:code)}')"
    U8Service.exec_sql sql
  end

  def exist_ht_in_u8?
    sql = "select count(*) from fitemss00 where citemcode='#{self.doc_no}'"
    result = U8Service.exec_sql sql
    result.count>0 and result.first['']>0
  end
  #==================================about filter================================

  #can delete depands on two things
  def can_destroy? user
    self.un_submit? and user.person==self.person
  end
  def can_edit? user
    (self.un_submit? or self.rejected?) and user.person==self.person
  end

  def person_dep
    person.dep.name
  end

  def doc_type_name
    doc_meta_info.display_name
  end
  def doc_state_name
    I18n.t("common_attr.#{state}") if state
  end
  #callbacks
  def total_amount
    total_apply_amount
  end


  ####################### vouch ##############################
  def exist_vouch?
    begin
      U8Service.exist_vouch doc_no
    rescue Exception=>msg
      Rails.logger.error "u8 service exist vouch error ,error msg is #{msg}"
      return false
    end
  end
  #vouch infos
  #this is a massive method which contains a lot of logic 
  #and 'if else'
  #把所有的获取fee_code_match的逻辑都放在各自的子条目中
  #保证每个子条目都有一个fee_code_match,project,dep
  def rg_vouches(cbill="")
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
          :cbill=>cbill,
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
        :cbill=>cbill,
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
        self.borrow_doc_details.each do |cp|
           vj=get_v ({:inid=>"#{jcount}",
           :code=>fee_m_code.dcode,
           :cbill=>cbill,
           :md=>cp.apply_amount,:md_f=>cp.apply_amount,
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
          :cbill=>cbill,
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
          :cbill=>cbill,
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
          :cbill=>cbill,
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
            :cbill=>cbill,
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
          :cbill=>cbill,
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
          rd_extra_work_meals.each {|w_m| total=w_m.final_amount+total}
          vj=get_v ({
            :inid=>"#{inid_count}",
            :code=>fee_m_code_meal.dcode,# dai kemu
            :cbill=>cbill,
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
          rd_extra_work_cars.each {|w_c| total=w_c.final_amount+total}
          vj=get_v ({
            :inid=>"#{inid_count}",
            :code=>fee_m_code_car.dcode,# dai kemu
            :cbill=>cbill,
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
          :cbill=>cbill,
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
            combined_benefits[combine_key][:amount]+=b.final_amount
          else
            combined_benefits[combine_key]={:dep=>b.dep,:project=>b.project,:amount=>b.final_amount,:fee=>fee_m_code}
          end
        end
        #这里进行真正的生成
        inid_count=1
        combined_benefits.each do |k,b|
          vj=get_v ({
            :inid=>"#{inid_count}",
            :code=>b[:fee].dcode,# dai kemu
            :cbill=>cbill,
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
          :cbill=>cbill,
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
              :cbill=>cbill,
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
              :cbill=>cbill,
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
              :cbill=>cbill,
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
          :cbill=>cbill,
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
    if Rails.env=="production"
      vouch_no=Sk.max_ino_id + 1
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
      :citem_id=>nil,#project code should select
      :ccode_equal=>""}
    default_opt.merge! options
  end

  def total_amount_can_not_be_zero
    errors.add(:base,'单据金额必须大于0') if total_apply_amount<=0
  end

  def first_approver_exist
    errors.add(:base,'不能确定第一个审批人，请联系财务人员') if !approver_infos.first.person_id
  end

  def set_afford_dep
    if project
      self.afford_dep = project.dep
    end
  end

  def set_current_approver_id
    self.current_approver_id = current_approver_info.person_id if current_approver_info
  end

  def set_doc_no
    if self.new_record?
      #set a number to
      doc_count_config=ConfigHelper.find_by_key(:doc_count) || ConfigHelper.create(:key=>"doc_count",:value=>"0") 
      if doc_count_config.value==5000
        doc_count_config.value="0"
      else
        doc_count_config.value=(doc_count_config.value.to_i+1).to_s
      end
      doc_count_config.save
      self.doc_no = doc_meta_info.code + Time.now.strftime("%Y%m%d")+doc_count_config.value.rjust(4,"0")
    end
  end

  def processing_doc_current_info_must_one_candidate
    errors.add(:base,'当前审批人不确定') if (self.processing? and self.current_approver_info and self.current_approver_info.candidates.count>1 and !self.current_approver_info.person_id)
  end



end
