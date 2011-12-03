#coding: utf-8
class BillAfter < ActiveRecord::Base
  has_paper_trail :class_name=>'VrvProjectVersion',
    :meta=>{:vrv_project_id => Proc.new{|r|r.vrv_project.id},
            :state => Proc.new{|r|r.vrv_project.state},
            :person_id => Proc.new{|r|r.vrv_project.person_id} }


  belongs_to :vrv_project

  BILL_STATE = %w(我方中标 我方未中标)
  CONTRACT = %w(合同正在协商中 合同内容已敲定，未签署 合同已经签署)
  MONEY_BACK = %w(一次付清 分批付款)

  validates :bill_state,:inclusion => BILL_STATE
  after_save :set_star

  private
  def set_star
    if self.valid? and self.vrv_project.system_star<4 and self.bill_state=='我方中标'
      self.vrv_project.update_attribute :system_star,4
    end
  end
end
