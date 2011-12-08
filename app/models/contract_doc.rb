#coding: utf-8
class ContractDoc < ActiveRecord::Base
  belongs_to :vrv_project
  validates_presence_of :customer,:vrv_project_id

  SOURCE = %w(直单 代理)
  DEPLOY_INFO = %w(北信源实施 代理方实施)
  validates :source,:inclusion => SOURCE
  validates :deploy_info,:inclusion => DEPLOY_INFO

  def customer_code
    if self.source=='直单'
      sql = "SELECT  cCusCode as code, cCusName as name FROM Customer where cCusName='#{customer}'"
      result = U8Service.exec_sql sql
      if !result.blank? and result.is_a?(Array) and !result.first.blank?
        result.first['code']
      else
        ''
      end
    else
      self.vrv_project.u8_customer.try(:code)
    end
  end

end
