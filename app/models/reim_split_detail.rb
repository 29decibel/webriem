#coding: utf-8
class ReimSplitDetail < ActiveRecord::Base
  belongs_to :dep
  belongs_to :project
  belongs_to :fee
  belongs_to :doc_head
  validates_presence_of :dep_id
  validate :dep_is_end
  def dep_is_end
    errors.add(:base,"部门必须为末级部门") if dep and dep.sub_deps.count>0
  end
end
