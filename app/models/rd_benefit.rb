#coding: utf-8
class RdBenefit < ActiveRecord::Base
  belongs_to :reim_detail
  belongs_to :dep
  belongs_to :fee
  belongs_to :project
  #validates_attachment_content_type :doc, :content_type => ['application/doc'] 
  has_many :uploads, :class_name => "UploadFile", :foreign_key => "p_id"
  validates_presence_of :apply_amount
  validates_presence_of :fee_id
  validates_presence_of :dep_id
  validates_presence_of :project_id
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"#{I18n.t('v_info.dep_is_end')}") if dep and dep.sub_deps.count>0
  end
  def amount
    fi_amount
  end
  def fcm
    fee_m_code=FeeCodeMatch.find_by_fee_code("04")
    if fee
      f=FeeCodeMatch.find_by_fee_code(fee.code)
      if f
        fee_m_code=f
      end
    end
    return fee_m_code
  end
end
