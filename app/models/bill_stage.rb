#coding: utf-8
class BillStage < ActiveRecord::Base
  has_paper_trail :class_name=>'VrvProjectVersion',
    :meta=>{:vrv_project_id => Proc.new{|r|r.vrv_project.id},
            :person_id => Proc.new{|r|r.vrv_project.person_id} }


  belongs_to :vrv_project
  SAMPLE_CHOOSE = %w(以我们的技术指标为标准 综合各家的技术指标 倾向于其他厂家 不知道)
  PRICE_POINT = %w(分值小于总分的20% 分值在总分的20%-35% 分值占总分值的35%以上 不知道)
  PRICE_CAL_WAY = %w(靶心中标法 允许多次报价 低价中标法 不知道)
  PRICE_SAMPLE = %w(最低价得最高分 均价得最高分 其他)

  validates :sample_choose,:inclusion => SAMPLE_CHOOSE
  validates :price_point,:inclusion => PRICE_POINT
  validates :price_cal_way,:inclusion => PRICE_CAL_WAY
  validates :price_sample,:inclusion => PRICE_SAMPLE
end
