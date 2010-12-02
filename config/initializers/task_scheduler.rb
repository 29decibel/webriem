require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new
#every day send a email
scheduler.cron '30 11 * * *' do
  send_email
end
def send_email
  # every day of the week at 22:00 (10pm)
  puts 'send emails to docs approver...'
  person_doc={}
  #set the person and the docs he should approver
  DocHead.where("doc_state=1").each do |doc|
    next if doc.approver==nil
    if person_doc[doc.approver]
      person_doc[doc.approver]<<doc
    else
      person_doc[doc.approver]=[doc]
    end
  end
  puts "total emails to send is #{person_doc.count}.................."
  #send the mail
  para={}
  person_doc.each do |person,docs|
    para[:email]= person.e_mail
    para[:docs_count]=docs.count
    para[:docs_total]=docs.inject(0) { |total,doc| total+=doc.total_apply_amount }
    puts "sending email to #{para[:mail]} docs count is #{para[:docs_count]} docs total is #{para[:docs_total]}"
    #WorkFlowMailer.notice_docs_to_approve para
    Delayed::Job.enqueue MailingJob.new(:notice_docs_to_approve, para)
  end
end
#test only
scheduler.every '30m' do
   #send_email
end
