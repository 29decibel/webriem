#coding: utf-8
class RdBenefit < ActiveRecord::Base
  include DocIndex
  include AdjustAmount
  before_validation :set_apply_amount
  def set_apply_amount
    self.apply_amount = self.rate * self.ori_amount
  end
  before_save :set_afford_dep
  def set_afford_dep
    if project
      self.dep = project.dep
    end
  end
  belongs_to :reim_detail
  belongs_to :dep
  belongs_to :fee
  belongs_to :project
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"
  #validates_attachment_content_type :doc, :content_type => ['application/doc'] 
  has_many :uploads, :class_name => "UploadFile", :foreign_key => "p_id"
  validates_presence_of :ori_amount
  validates_presence_of :fee_id
  validates_presence_of :project_id
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
