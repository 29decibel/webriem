class MailingJob < Struct.new(:notifier_method,:approver,:doc_head)  
  def perform 
    WorkFlowMailer.send(notifier_method, approver,doc_head).deliver  
  end  
end