require 'rubygems'

task :send_mail => :environment do
  # every day of the week at 22:00 (10pm)
  Rails.logger.info "send emails to docs approver..."
  person_doc={}
  #set the person and the docs he should approver
  DocHead.where("doc_state=1").each do |doc|
    next if doc.current_approver_id==nil
    Rails.logger.info "+++++ doc id is #{doc.id}  begin ++++++"
    p = Person.find_by_id(doc.current_approver_id)
    next if p==nil
    if person_doc[p]
      person_doc[p]<<doc
    else
      person_doc[p]=[doc]
    end
    Rails.logger.info "____+++++ doc id is #{doc.id}  end ++++++____"
  end
  Rails.logger.info "total emails to send is #{person_doc.count}.................."
  #send the mail
  para={}
  person_doc.each do |person,docs|
    send_mail_address = RAILS_ENV=="development" ? "mike.d.1984@gmail.com" : person.e_mail
    Rails.logger.info "$$$$$$$$$ address:  #{send_mail_address}   $$$$$$"
    send_mail_address = "mike.d.1984@gmail.com"
    para[:email]= send_mail_address
    para[:docs_count]=docs.count
    para[:docs_total]=docs.inject(0) { |total,doc| total+=doc.total_apply_amount }
    Rails.logger.info "sending email to #{para[:mail]} docs count is #{para[:docs_count]} docs total is #{para[:docs_total]}"
    #WorkFlowMailer.notice_docs_to_approve para
    Delayed::Job.enqueue MailingJob.new(:notice_docs_to_approve, para)
  end
end
