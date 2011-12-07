#coding: utf-8
class DocHead < ActiveRecord::Base
  include DocHeadVouch
  belongs_to :dep
  belongs_to :person
  belongs_to :afford_dep, :class_name => "Dep", :foreign_key => "afford_dep_id"
  belongs_to :real_person, :class_name => "Person", :foreign_key => "real_person_id"
  belongs_to :project
  belongs_to :doc_meta_info
  belongs_to :settlement

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
    logger.info '~~~~~~ gogogogogogog'
    return unless self.processing?
    logger.info "~~~~~~~#{'begin set next approver'}"
    approver_array = approver_infos.enabled.all
    logger.info "~~~~~~~approver_array is #{approver_array}"
    current_index = approver_array.index current_approver_info
    logger.info "~~~~~~~cuttent approver info is #{current_approver_info}"
    logger.info "~~~~~~~cuttent index is #{current_index}"

    # TODO should skip the disabled ones
    if current_index!=nil
      self.work_flow_infos << WorkFlowInfo.create(:is_ok=>true,:comments=>comments,:approver_id=>self.current_approver_id) 
      if current_index+1<approver_array.count
        logger.info '~~~~~~~~ next approver'
        self.current_approver_info = approver_array[current_index+1]
        self.save
      else
        logger.info '~~~~~~~~ approver end ~~~~~~'
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
    Rails.logger.info self.approver_infos.count
    if self.approver_infos.count>0
      Rails.logger.info '!!!!!!!!!!!!!!!!!!!!!'
      self.current_approver_info = approver_infos.first
      self.save
      Rails.logger.info self.errors.full_messages
    end
    logger.info "current approver infos is #{self.current_approver_info}"
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

  def destroy_ht_in_u8
    d_sqls= [ "delete from fitemss00 where citemcode='#{self.doc_no}'",
      "delete from CM_Contract_Main where strContractID='#{self.doc_no}'",
      "delete from CM_Contract_B where strcontractid='#{self.doc_no}'",
      "delete from CM_Contract_Item_B where strcontractid='#{self.doc_no}'"]
    d_sqls.each {|s| U8Service.exec_sql s}
  end

  def send_ht_to_u8
    return '合同信息不存在' if self.contract_doc.blank?
    # check customer
    return '客户编码不存在' if self.contract_doc.customer_code.blank?
    return if self.doc_meta_info.code!='HT'
    result = []
    result << "fitemss00[#{send_ht_to_u8_fitem}]"
    result << "CM_Contract_Main[#{send_ht_to_u8_contract_main}]"
    result << "CM_Contract_B[#{send_ht_to_u8_contract_b}]"
    result << "CM_Contract_Item_B[#{send_ht_to_u8_item}]"
    result.join(',')
  end

  #citemcode  销售合同号
  #citemname  合同名称
  #citemccode 项目分类编码  默认为000
  #bclose     是否结算      默认为 false
  #对应立项号 对应立项号      文本--插入合同审批表中的项目立项号
  def send_ht_to_u8_fitem
    # insert into first table
    sql = "insert into fitemss00(citemcode,citemname,citemccode,bclose,对应立项号)
          values('#{self.doc_no}','#{self.contract_doc.name}','#{'000'}','#{false}','#{self.contract_doc.vrv_project.try(:code)}')"
    U8Service.exec_sql(sql).to_s
  end

  def send_ht_to_u8_contract_main
    table = 'CM_Contract_Main'
    conditions = {
      :strContractID=>doc_no,
      :strRel=>'0', 
      :strSource=>'1', 
      :intDetail=>'0', 
      :intMustDetail=>'0', 
      :strTempleteShowID=>'',
      :strTempletePrintID=>'', 
      :intKL=>'0', 
      :strSpare1=>'1', 
      :strSpare2=>'日常合同默认模板组',
      :strSpare3=>'1',
      :dblPreAPARCurrency=>'0', 
      :dblPreAPARCurrencyRMB=>'0', 
      :strTaxRatio=>''
    }
    sql = "insert into #{table}#{conditions_sql(conditions)}"
    puts sql
    U8Service.exec_sql(sql).to_s
  end



  def send_ht_to_u8_contract_b
    table = 'CM_Contract_B'
    conditions = {
      :Guid =>['NEWID()'],
      :strContractName => contract_doc.name,
      :strBisectionPerson => contract_doc.contact_person,
      :strcontractorderdate => apply_date,
      :strContractStartDate => Time.now,
      :strContractEndDate => Time.now,
      :strSetupPerson => person.try(:name),
      :strSetupDate => apply_date,
      :strDeptID => person.dep.try(:code),
      :strPersonID => person.try(:code),
      :dblTotalCurrency => total_amount,
      :dtCreateTime => Time.now,
      :strcontractid => doc_no,
      :strBisectionUnit => self.contract_doc.customer_code,
      :strContractType =>'0101',
      :strContractKind =>'销售类合同',
      :strParentID => '',
      :strRepair =>'',
      :strContractDesc => '',
      :dblMassassureScale =>0,
      :dblMassassure =>0,
      :cDefine1 =>self.contract_doc.vrv_project.u8_customer.try(:name),
      :cDefine2 =>'',
      :cdefine3 =>'',
      :cdefine4 =>nil,
      :cdefine5 =>0,
      :cDefine6 =>nil,
      :cDefine7 =>0,
      :cDefine8 =>'',
      :cDefine9 =>self.contract_doc.vrv_project.u8_customer.try(:code),
      :cDefine10 =>'',
      :cDefine11 =>'',
      :cDefine12 =>'',
      :cDefine13 =>'',
      :cDefine14 =>'',
      :cDefine15 =>0,
      :cDefine16 =>0,
      :strEndCasePerson =>'',
      :strEndCaseDate =>nil,
      :strInurePerson =>'',
      :strInureDate =>nil,
      :intVaryID =>nil,
      :strVaryCauseID =>nil,
      :dtVaryDate =>nil,
      :strVaryPersonID =>nil,
      :strVaryPassPersonID =>nil,
      :intPre =>0,
      :strWay => '收',
      :strCurrency => '人民币',
      :dblExchange => '1',
      :strVaryPerson =>nil,
      :strSpare1 =>nil,
      :strSpare2 =>nil,
      :strSpare3 =>nil,
      :strSource => 'C',
      :dblExecCurrency =>0,
      :dblTotalQuantity =>0,
      :dblExecQuqantity =>0,
      :cbustype => '普通销售',
      :cSCCode =>nil,
      :cGatheringPlan =>'',
      :iswfcontrolled =>0,
      :iverifystate =>0,
      :ireturncount =>0,
      :intAuditSymbol =>0,
      :cZbjComputeMode => 'total',
      :dtZbjStartDate =>nil,
      :dtZbjEndDate =>nil,
      :bUseStage =>0,
      :cStageGroupCode =>'',
      :dtModifyTime =>nil,
      :dtModifyDate =>nil,
      :dteffecttime =>nil,
      :cModifer =>'',
      :dtVaryCreateDate =>nil,
      :dtVaryCreateTime =>nil,
      :dtVaryModifyTime =>nil,
      :dtVaryModifyDate =>nil,
      :dtVaryEffectTime =>nil,
      :cVaryModifer =>nil
    }
    sql = "insert into #{table}#{conditions_sql(conditions)}"
    puts sql
    U8Service.exec_sql(sql).to_s
  end

  def u8_ht_guid
    sql = "select GUID from CM_Contract_B where(strcontractid='#{doc_no}')"
    U8Service.exec_sql(sql).first['GUID']
  end

  def send_ht_to_u8_item
    results = ''
    ht_guid = u8_ht_guid
    return if ht_guid.blank?
    table = 'CM_Contract_Item_B'
    tax = SystemConfig.value('contract_tax') || 17
    contract_items.each_with_index do |item,index|
      conditions = {
        :Guid => u8_ht_guid,
        :strcode =>"#{item.product.category}#{item.product.code}",
        :strname => item.product.name,
        :dblquantity => [item.quantity],
        :strmeasureunit => '个',
        :dbltaxratio => [tax],
        :dbluntaxprice => [(item.amount-(item.amount*tax/100))/item.quantity],
        :dbluntaxpricermb => [(item.amount-(item.amount*tax/100))/item.quantity],
        :dblprice => [item.price],
        :dblpricermb => [item.price],
        :dbluntaxsum => [item.amount-(item.amount*tax/100)],
        :dbluntaxsumrmb => [item.amount-(item.amount*tax/100)],
        :dblsum => [item.amount],
        :dblsumrmb => [item.amount],
        :strchief => item.product.code,
        :strinvoiceid => item.product.code,
        :strMemo => contract_doc.contract_info,
        :strxmdl => "#{item.product.category}#{item.product.code},#{item.product.category}#{item.product.code},1",
        :strcontractid =>  doc_no,
        :rowguid => ['NEWID()'],
        :intflag =>0,
        :dbluntaxexecsum =>0,
        :dbluntaxexecsumrmb =>0,
        :dblexecsum =>0,
        :dblexecsumrmb =>0,
        :dtStartDate =>nil,
        :dtEndDate =>nil,
        :strcorrsource => '存货',
        :strCorrItemID =>nil,
        :dblDiscountRatio => '100',
        :cdefine22 =>nil,
        :cdefine23 =>nil,
        :cDefine24 =>nil,
        :cdefine25 => '',
        :cDefine26 =>nil,
        :cDefine27 =>nil,
        :cDefine28 =>nil,
        :cDefine29 =>nil,
        :cDefine30 =>nil,
        :cDefine31 =>nil,
        :cDefine32 =>nil,
        :cDefine33 =>nil,
        :cdefine34 =>nil,
        :cDefine35 =>nil,
        :cDefine36 =>nil,
        :cDefine37 =>nil,
        :dblExecQuantity =>0,
        :intend => '1',
        :strSpare1 =>nil,
        :strSpare2 =>nil,
        :strSpare3 =>nil,
        :cFree1 =>nil,
        :cFree2 =>nil,
        :cFree3 =>nil,
        :cFree4 =>nil,
        :cFree5 =>nil,
        :cFree6 =>nil,
        :cFree7 =>nil,
        :cFree8 =>nil,
        :cFree9 =>nil,
        :cFree10 =>nil,
        :cInvDefine1 =>nil,
        :cInvDefine2 =>nil,
        :cInvDefine3 =>nil,
        :cInvDefine4 =>nil,
        :cInvDefine5 =>nil,
        :cInvDefine6 =>nil,
        :cInvDefine7 =>nil,
        :cInvDefine8 =>nil,
        :cInvDefine9 =>nil,
        :cInvDefine10 =>nil,
        :cInvDefine11 =>nil,
        :cInvDefine12 =>nil,
        :cInvDefine13 =>nil,
        :cInvDefine14 =>nil,
        :cInvDefine15 =>nil,
        :cInvDefine16 =>nil,
        :cinvstd =>nil,
        :ccuscode =>nil,
        :cvencode =>nil,
        :AuxMeasureUnit => '',
        :ConversionRate =>0,
        :PieceNum =>0,
        :ExecPieceNum =>0,
        :iInvRCost =>0,
        :cinvaddcode =>0,
        :decZbjRatio =>0,
        :decNoRateZbjMoney =>0,
        :decNoRateZbjBenBiMoney =>0,
        :decZbjMoney =>0,
        :decZbjBenbiMoney =>nil,
        :dtZbjStartDate =>nil,
        :dtZbjEndDate =>nil,
        :iAppIds =>nil,
        :cAppCode =>nil
      }
      sql = "insert into #{table}#{conditions_sql(conditions)}"
      results << U8Service.exec_sql(sql).to_s
    end
    results
  end

  def conditions_sql(conditions)
    cols = []
    values = []
    conditions.each_pair do |k,v|
      cols << k.to_s
      if v
        values << (v.is_a?(Array) ? v.first : "'#{v.to_s}'")
      else
        values << 'null'
      end
    end
    "(#{cols.join(',')}) values(#{values.join(',')})"
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
    select_cmd = "select count(*) from gl_accvouch where cdigest like '%#{doc_no}%'"
    U8Service.exec_sql(select_cmd).first[""] > 0
  end

  def max_ino_id
    select_cmd = "select max(ino_id) from GL_accvouch where iperiod='#{Time.now.month}'"
    puts select_cmd
    U8Service.exec_sql(select_cmd).first[""]||0
  end
                                 
  def generate_vouch_v2
    self.vouches.clear
    # get all datas
    doc_meta_info.doc_relations.each do |dr|
      next if !dr.multiple
      data_rows = self.send(eval(dr.doc_row_meta_info.name).table_name)
      data_rows.each do |row|
        d = (row.respond_to?(:afford_dep) && row.try(:afford_dep)) || (row.respond_to?(:dep)&&row.try(:dep)) || self.afford_dep || self.person.dep
        p = (row.respond_to?(:project) && row.try(:project)) || self.project
        # 借
        puts row
        puts 'begin create vouch '
        self.vouches.create(
          :dep=>dep,
          :project=>p,
          :person=>person,
          :r_ccode=>row.fee_type.ccode,
          :r_ccode_equal=>self.settlement.try(:ccode)||U8code.find_by_ccode(SystemConfig.value('default_ccode')),
          :md => DocAmountChange.final_amount(row),
          :md_f=>DocAmountChange.final_amount(row))
        # 贷
        self.vouches.create(
          :dep=>dep,
          :project=>p,
          :person=>person,
          :r_ccode=>self.settlement.try(:ccode)||U8code.find_by_ccode(SystemConfig.value('default_ccode')),
          :r_ccode_equal=>row.fee_type.ccode,
          :mc => DocAmountChange.final_amount(row),
          :mc_f=>DocAmountChange.final_amount(row))
      end
    end
  end

  def send_vouch_to_u8
    ino_id = max_ino_id + 1
    count = 1
    if vouches.count>0
      self.vouches.jie.each do |v,i|
        result = v.send_to_u8(ino_id,count)
        break if result!='1'
        count+=1
      end
      self.vouches.dai.each do |v,i|
        result = v.send_to_u8(ino_id,count)
        break if result!='1'
        count+=1
      end
    end
  end

  def destroy_vouch
    delete_cmd = "delete gl_accvouch where cdigest like '%#{self.doc_no}%'"
    U8Service.exec_sql delete_cmd
  end

  # 生成出库申请单
  def generate_ck_doc(type='S')
    return nil if doc_meta_info.code!='HT'
    doc = DocHead.create :doc_meta_info=>DocMetaInfo.find_by_code("CK_#{type}"),
      :person=>self.person,:apply_date=>Time.now
    outware_doc = doc.create_outware_doc_detail :contract_no=>self.doc_no,
      :customer=>self.contract_doc.customer,:ip_address=>self.contract_doc.ip_address,
      :contact_person=>self.contract_doc.contact_person,:agent=>self.contract_doc.agent,
      :agent_phone=>self.contract_doc.agent_phone,:agent_name=>self.contract_doc.agent_name,
      :pay_info=>self.contract_doc.pay_info
    # create sub items
    self.contract_items.each do |ci|
      doc.contract_items.create :product_id=>ci.product_id,:quantity=>ci.quantity,:price=>ci.price,:amount=>ci.amount,:service_year=>ci.service_year
    end
    doc
  end
 
  private
  def rows_amount(rows)
    rows.inject(0){|sum,row| sum + DocAmountChange.final_amount(row) }
  end

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
