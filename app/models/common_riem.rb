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
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if dep and dep.sub_deps.count>0
  end
  def amount
    apply_amount
  end
end
