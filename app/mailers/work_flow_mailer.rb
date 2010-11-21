#coding: utf-8
#this mailer is used for work flow
class WorkFlowMailer < ActionMailer::Base
  layout 'mailer_layout'
  default :from => "mike.d.1984@gmail.com"
  # 1.paid 已经付款 
  def doc_paid(para)
    @docs_total=para[:docs_total]
    mail :to=>para[:email],:subject=>"您的报销单已付款 Doc Paid.."
  end
  # 2.doc failed send by hand
  def doc_failed(para)
    mail :to=>para[:email],:subject=>"发票不合格，请重新粘贴 Invoice is not valid, please check it again.."
  end
  # 3.not passed
  def doc_not_passed(para)
    @docs_count=para[:docs_count]
    @docs_total=para[:docs_total]
    mail :to=>para[:email],:subject=>"单据未审批通过 Docs Not Approved.."
  end
  # 4.amount changed but passed 
  def amount_change_and_passed(para)
    @riem_amount=para[:riem_amount]
    @approve_amount=para[:approve_amount]
    mail :to=>para[:email],:subject=>"报销单据金额更改通知 Your Doc 's Amount Has Been Changed By Admin"
  end
  # 5.notice the approver mails
  def notice_docs_to_approve(para)
    @docs_count=para[:docs_count]
    @docs_total=para[:docs_total]
    mail :to=>para[:email],:subject=>"您有单据需要审批 You Have Docs To Approve"
  end
end
