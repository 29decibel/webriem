#coding: utf-8
class RdBenefit < ActiveRecord::Base
  belongs_to :reim_detail
  belongs_to :dep
  belongs_to :fee
  belongs_to :project
  #validates_attachment_content_type :doc, :content_type => ['application/doc'] 
  has_many :uploads, :class_name => "UploadFile", :foreign_key => "p_id"
  validates_presence_of :apply_amount
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"部门必须为末级部门") if dep and dep.sub_deps.count>0
  end
end
