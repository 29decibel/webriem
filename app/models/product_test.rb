#coding: utf-8
class ProductTest < ActiveRecord::Base
  has_paper_trail
  belongs_to :vrv_project
  CUSTOMER = %w(技术工程师 主管主任 其他)
  SAMPLE = %w(我们可建议用户以我方高技术指标为标准 用户自行选定标准，无法控制 以其他产品技术指标为准)
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
end
