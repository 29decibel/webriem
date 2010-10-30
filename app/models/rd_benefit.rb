class RdBenefit < ActiveRecord::Base
  belongs_to :reim_detail
  #validates_attachment_content_type :doc, :content_type => ['application/doc'] 
  has_many :uploads, :class_name => "UploadFile", :foreign_key => "p_id"
  validates_presence_of :amount
end
