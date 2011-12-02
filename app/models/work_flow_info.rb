#coding: utf-8
class WorkFlowInfo < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :vrv_project
  belongs_to :approver, :class_name => "Person", :foreign_key => "approver_id"

  before_validation :check_spam

  private
  def check_spam
    last = doc_head_id ? WorkFlowInfo.where('doc_head_id=?',doc_head_id).order('created_at').last :
      WorkFlowInfo.where('vrv_project_id=?',vrv_project_id).order('created_at').last
    return if !last
    puts last
    if last.approver_id==self.approver_id and last.is_ok==self.is_ok and last.comments==self.comments
      puts 'some errors '
      logger.info 'can not create workflow some errors'
      self.errors.add(:base,'不要重复提交审批')
    end
  end
end
