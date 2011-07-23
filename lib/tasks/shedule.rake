#coding: utf-8
namespace :schedule do

  desc "Import gpm project"
  task :update_gpm_projects => :environment do
    projs=U8service::API.get_gpm_projects
    if projs and projs.count>0
      projs.each do |p|
        if p.valid?
          p.status=1 and p.save 
        end
      end
    end
  end


  desc "Docs to approve email alert"
  task :alert_docs_to_approve => :environment do
    # every day of the week at 22:00 (10pm)
    Rails.logger.info "send emails to docs approver..."
    person_doc={}
    #set the person and the docs he should approver
    DocHead.where("state='processing'").each do |doc|
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
      send_mail_address = Rails.env=="production" ? person.e_mail : "ldb1984@gmail.com" 
      Rails.logger.info "$$$$$$$$$ address:  #{send_mail_address}   $$$$$$"
      para[:email]= send_mail_address
      para[:docs_count]=docs.count
      para[:docs_total]=docs.inject(0) { |total,doc| total+=doc.total_amount }
      Rails.logger.info "sending email to #{para[:mail]} docs count is #{para[:docs_count]} docs total is #{para[:docs_total]}"
      #WorkFlowMailer.notice_docs_to_approve para
      Resque.enqueue(MailWorker, :notice_docs_to_approve,para)
    end
  end

end
