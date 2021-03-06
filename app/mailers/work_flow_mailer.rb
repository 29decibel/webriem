#coding: utf-8
#this mailer is used for work flow
class WorkFlowMailer < ActionMailer::Base
  layout 'mailer_layout'
  default :from => "baoxiao@vrvmail.com.cn" #注意 这里的东西必须和你的smtp登陆的邮件人一致
  default_url_options[:host] = "211.154.169.179"
  # 1.paid 已经付款 
  def doc_paid(para)
    @para=para
    #for teest
    #para[:email]="mike.d.1984@gmail.com"
    mail :to=>para["email"],:subject=>"您的报销单已付款 Doc Paid.."
  end
  # 2.doc failed send by hand
  def doc_failed(para)
    @para=para
    #for teest
    #para[:email]="mike.d.1984@gmail.com"
    mail :to=>para["email"],:subject=>"发票不合格，请重新粘贴 Invoice is not valid, please check it again.."
  end
  # 3.not passed
  def doc_not_passed(para)
    @para=para
    #for teest
    #para[:email]="mike.d.1984@gmail.com"
    mail :to=>para["email"],:subject=>"单据未审批通过 Docs Not Approved.."
  end
  # 4.amount changed but passed 
  def amount_change_and_passed(para)
    @para=para
    #for teest
    #para[:email]="mike.d.1984@gmail.com"
    mail :to=>para["email"],:subject=>"报销单据金额更改通知 Your Doc 's Amount Has Been Changed By Admin"
  end
  # 5.notice the approver mails
  def notice_docs_to_approve(para)
    @para=para
    #for teest
    #para[:email]="mike.d.1984@gmail.com"
    #mail("X-Spam" => para[:email])
    mail :to=>para["email"],:subject=>"您有单据需要审批 You Have Docs To Approve"
  end
end
