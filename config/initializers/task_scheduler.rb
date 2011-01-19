require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new
#every day send a email
scheduler.cron '00 13 * * *' do
  send_email
end
#every day send a email
scheduler.cron '00 01 * * *' do
  send_email
end
def send_email
  # every day of the week at 22:00 (10pm)
  puts 'send emails to docs approver...'
  person_doc={}
  #set the person and the docs he should approver
  DocHead.where("doc_state=1").each do |doc|
    next if doc.current_approver_id==nil
    p = Person.find_by_id(doc.current_approver_id)
    next if p==nil
    if person_doc[p]
      person_doc[p]<<doc
    else
      person_doc[p]=[doc]
    end
  end
  puts "total emails to send is #{person_doc.count}.................."
  #send the mail
  para={}
  person_doc.each do |person,docs|
    para[:email]= "mike.d.1984@gmail.com"#person.e_mail
    para[:docs_count]=docs.count
    para[:docs_total]=docs.inject(0) { |total,doc| total+=doc.total_apply_amount }
    puts "sending email to #{para[:mail]} docs count is #{para[:docs_count]} docs total is #{para[:docs_total]}"
    #WorkFlowMailer.notice_docs_to_approve para
    Delayed::Job.enqueue MailingJob.new(:notice_docs_to_approve, para)
  end
end
#test only
scheduler.every '2s' do
   #send_email
end
