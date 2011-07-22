class MailWorker
  @queue = :mailer_queue
  def self.perform(mail_method,para)
    WorkFlowMailer.send(mail_method, para).deliver  
  end
end
