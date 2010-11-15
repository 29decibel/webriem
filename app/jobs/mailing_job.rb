class MailingJob < Struct.new(:mail_method,:para)  
  def perform 
    WorkFlowMailer.send(mail_method, para).deliver  
  end  
end