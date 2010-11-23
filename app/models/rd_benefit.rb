class RdBenefit < ActiveRecord::Base
  belongs_to :reim_detail
  belongs_to :dep
  belongs_to :fee
  belongs_to :project
  #validates_attachment_content_type :doc, :content_type => ['application/doc'] 
  has_many :uploads, :class_name => "UploadFile", :foreign_key => "p_id"
  validates_presence_of :apply_amount
end
