#coding: utf-8
namespace :schedule do

  desc "Import gpm project"
  task :import_gpm_projects => :environment do
    projs=U8service::API.get_gpm_projects
    if projs and projs.count>0
      projs.each do |p|
        if p.valid?
          p.status=1 and p.save 
        end
      end
    end
  end

  desc "import u8 codes"
  task :import_u8_codes => :environment do
    begin
      u8codes= Sk.get_codes
      #never delete 
      this_time_count=0
      u8codes.each do |u8_model|
        #current year not exist then create
        next if U8code.where("year =#{Time.now.year} and ccode=#{u8_model["ccode"]}").count>0
        model=U8code.new
        model.cclass=u8_model["cclass"]
        model.ccode=u8_model["ccode"]
        model.ccode_name=u8_model["ccode_name"]
        model.igrade=u8_model["igrade"]
        model.bend=u8_model["bend"]
        model.cexch_name=u8_model["cexch_name"]
        model.bperson=u8_model["bperson"]
        model.bitem=u8_model["bitem"]
        model.bdept=u8_model["bdept"]
        model.year=Time.now.year
        model.save
        this_time_count=this_time_count+1
      end
    rescue Exception=>msg
      Rails.logger.error "^^^^^^^^^^^^^^^can't get the u8 serivce to get the codes info"
      Rails.logger.error "#{msg}"
    end
  end


  desc "import u8 deps"
  task :import_u8_deps => :environment do
    U8Dep.delete_all
     begin
      u8deps= Sk.get_departments
      #never delete 
      this_time_count=0
      u8deps.each do |u8_model|
        model=U8Dep.new
        model.cdepcode=u8_model["cDepCode"]
        model.bdepend=u8_model["bDepEnd"]
        model.cdepname=u8_model["cDepName"]
        model.idepgrade=u8_model["iDepGrade"]
        model.save
        this_time_count=this_time_count+1
      end
    rescue Exception=>msg
      Rails.logger.error "^^^^^^^^^^^^^^^can't get the u8 serivce to get the departments info"
      Rails.logger.error "#{msg}"
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

  desc "test mail"
  task :test_mail => :environment do
    test_mails = ['79413824@qq.com','mike.d.1984@gmail.com','ldb1984@gmail.com']
    test_mails.each do |mail|
      para = {}
      para[:email]= mail
      para[:docs_count] = 332
      para[:docs_total] = 23
      Resque.enqueue(MailWorker, :notice_docs_to_approve,para)     
    end
  end
end
