#coding: utf-8
class CommonRiem < ActiveRecord::Base
  belongs_to :currency
  belongs_to :dep
  belongs_to :project
  belongs_to :doc_head
  validates_presence_of :dep_id
  validates_presence_of :project_id
  validates_presence_of :description
  validates_presence_of :currency_id
  validates_presence_of :rate
  validates_presence_of :ori_amount
  def after_initialize
    self.currency=Currency.find_by_code("RMB")
    if self.currency
      self.rate=self.currency.default_rate
    end
  end
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"部门必须为末级部门") if dep and dep.sub_deps.count>0
  end
end
