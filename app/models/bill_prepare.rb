#coding: utf-8
class BillPrepare < ActiveRecord::Base
  has_paper_trail :class_name=>'VrvProjectVersion',
    :meta=>{:vrv_project_id => Proc.new{|r|r.vrv_project.id},
            :state => Proc.new{|r|r.vrv_project.state},
            :person_id => Proc.new{|r|r.vrv_project.person_id} }


  belongs_to :vrv_project
  after_save :update_star
  SAMPLE_CHOOSE = %w(以我们的技术指标为标准 综合各家的技术指标 倾向于其他厂家 不知道)
  PRICE_POINT = %w(分值小于总分的20% 分值在总分的20%-35% 分值占总分值的35%以上 不知道)
  PRICE_CAL_WAY = %w(靶心中标法 允许多次报价 低价中标法 不知道)

  validates :sample_choose,:inclusion => SAMPLE_CHOOSE
  validates :price_point,:inclusion => PRICE_POINT
  validates :price_cal_way,:inclusion => PRICE_CAL_WAY

  def product_test
    vrv_project.product_test
  end

  private
  def update_star
    if self.valid? and self.vrv_project.star<3 and self.product_test
      if self.product_test.sample_state=='测试指标以我公司技术指标为准' or self.product_test.test_result=='我们最好'
        self.vrv_project.update_attribute(:system_star,3) 
      end
    end
  end
end
