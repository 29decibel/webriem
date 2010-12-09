#coding: utf-8
class CpDocDetail < ActiveRecord::Base
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"
  belongs_to :dep
  belongs_to :fee
  belongs_to :project
  belongs_to :currency
  validates_presence_of :dep_id
  validates_presence_of :ori_amount
  validates_presence_of :currency_id
  validates_presence_of :rate
  validates_presence_of :used_for
  def after_initialize
    if self.new_record?
      self.currency=Currency.find_by_code("RMB")
      if self.currency
        self.rate=self.currency.default_rate
      end
    end
  end
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if dep and dep.sub_deps.count>0
  end
end
