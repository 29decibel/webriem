#coding: utf-8
class RecNoticeDetail < ActiveRecord::Base
  before_save :set_afford_dep
  def set_afford_dep
    if project
      self.dep = project.dep
    end
  end
  belongs_to :dep
  belongs_to :project
  belongs_to :doc_head
  belongs_to :currency
  validates_presence_of :dep_id
  validates_presence_of :currency_id
  validates_presence_of :project_id
  validates_presence_of :ori_amount
  validates_numericality_of :ori_amount
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if dep and dep.sub_deps.count>0
  end
end
