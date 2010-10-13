class RdBenefit < ActiveRecord::Base
  belongs_to :reim_detail  
  has_attached_file :details
  #validates_attachment_content_type :doc, :content_type => ['application/doc'] 
end
