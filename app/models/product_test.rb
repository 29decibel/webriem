#coding: utf-8
class ProductTest < ActiveRecord::Base
  has_paper_trail :class_name=>'VrvProjectVersion',
    :meta=>{:vrv_project_id => Proc.new{|r|r.vrv_project.id},
            :person_id => Proc.new{|r|r.vrv_project.person_id} }


  belongs_to :vrv_project
  after_save :update_star
  CUSTOMER = %w(技术工程师 主管主任 其他)
  SAMPLE = %w(我们可建议用户以我方高技术指标为标准 用户自行选定标准，无法控制 以其他产品技术指标为准 客户是否制定VRV品牌)
  SAMPLE_STATE = %w(测试指标以我公司技术指标为准 融合了几家的技术指标 以其他产品技术指标为主)
  CUSTOMER_ATTITUDE = %w(特别友好配合 不清楚对方意图 感觉明显不好)
  TEST_RESULT = %w(我们最好 各有千秋 对我们不利)
  HAS_TECH_PEOPLE = %w(有 无)
  TECH_PEOPLE_POINT = %w(测试前充分准备 未理解客户意图 技术水平有问题)

  validates :customer,:inclusion => CUSTOMER
  validates :sample,:inclusion => SAMPLE
  validates :sample_state,:inclusion => SAMPLE_STATE
  validates :customer_attitude,:inclusion => CUSTOMER_ATTITUDE
  validates :test_result,:inclusion => TEST_RESULT
  validates :has_tech_people,:inclusion => HAS_TECH_PEOPLE
  validates :tech_people_point,:inclusion => TECH_PEOPLE_POINT

  # 三星标准
  # 1.产品测试中【已发出情况】中选择“测试指标以我公司为准”或者【测试结果】是“我们最好”，
  # 并且招标准备中
  # 至少勾选一项
  # 2.指标选定中勾选第一个或者“客户是否制定VRV品牌”（新增）
  
  def bill_prepare
    self.vrv_project.bill_prepare
  end

  def update_star
    if self.valid?
      if self.vrv_project.star<2 
        self.vrv_project.update_attribute(:system_star,2) 
      end
      if self.vrv_project.star<3
        if %w(我们可建议用户以我方高技术指标为标准 客户是否制定VRV品牌).include?(sample)
          self.vrv_project.update_attribute(:system_star,3) 
        end
        if bill_prepare and (self.sample_state=='测试指标以我公司技术指标为准' or self.test_result=='我们最好')
          self.vrv_project.update_attribute(:system_star,3) 
        end
      end
    end
  end
end
