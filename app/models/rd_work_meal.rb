#coding: utf-8
class RdWorkMeal < ActiveRecord::Base
  belongs_to :reim_detail
  belongs_to :currency
  belongs_to :dep
  belongs_to :project
  validates_presence_of :place
  validates_presence_of :meal_date
  validates_presence_of :people_count
  validates_presence_of :person_names
  validates_presence_of :reason
  validates_presence_of :ori_amount
  validates_presence_of :currency_id
  validates_presence_of :rate
  validates_presence_of :dep_id
  validates_presence_of :project_id
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if dep and dep.sub_deps.count>0
  end
  def amount
    apply_amount
  end
  def fcm
    if doc_head.doc_type==12
      return FeeCodeMatch.find_by_fee_code("0102")
    else
      return FeeCodeMatch.find_by_fee_code("02")
    end
  end
end
