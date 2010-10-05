#coding: utf-8
class WorkFlowMailer < ActionMailer::Base
  default :from => "mike.d.1984@gmail.com"
  #the notice of approving 
  def notice_need_approve(approver,doc_head)
    @approver=approver
    @doc_head=doc_head
    mail :to=>approver.e_mail,:subject=>"单据审批提醒"
  end
  #send mail to the person who have the doc
  def notice_aaplyer(approver,doc_head)
    @approver=approver
    @doc_head=doc_head
    mail :to=>doc_head.person.e_mail,:subject=>"单据审批通知"
  end
end
