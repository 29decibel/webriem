#coding: utf-8
class WorkFlowInfo < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :person, :class_name => "Person", :foreign_key => "people_id"
  blongs_to_name_attr :person
  enum_attr :is_ok, [["#{I18n.t('common_attr.__not')}",0],["#{I18n.t('common_attr.__ok')}", 1]]
  #validates_uniqueness_of :people_id, :scope => [:doc_head_id]
  #validate :approve_too_fast
  #两次审批的间隔时间必须大于1分钟
  def approve_too_fast
    info=WorkFlowInfo.where("people_id=? and doc_head_id=?",people_id,doc_head_id)
  end
end
