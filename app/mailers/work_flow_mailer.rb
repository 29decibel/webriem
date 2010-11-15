#coding: utf-8
#this mailer is used for work flow
class WorkFlowMailer < ActionMailer::Base
  layout 'mailer_layout'
  default :from => "eos@skccsystems.cn"
  # 1.paid 已经付款 
  def doc_paid(para)
    @docs_total=para[:docs_total]
    mail :to=>para[:email],:subject=>"Doc Paid.."
  end
  # 2.doc failed send by hand
  def doc_failed(para)
    mail :to=>para[:email],:subject=>"Invoice is not valid, please check it again.."
  end
  # 3.not passed
  def doc_not_passed(para)
    @docs_count=para[:docs_count]
    @docs_total=para[:docs_total]
    mail :to=>para[:email],:subject=>"Docs Not Approved.."
  end
  # 4.amount changed but passed 
  def amount_change_and_passed(para)
    @riem_amount=para[:riem_amount]
    @approve_amount=para[:approve_amount]
    mail :to=>para[:email],:subject=>"Amount changed and Doc Approved.."
  end
  # 5.notice the approver mails
  def notice_docs_to_approve(para)
    @docs_count=para[:docs_count]
    @docs_total=para[:docs_total]
    mail :to=>para[:email],:subject=>"Docs Need To Approve.."
  end
end
