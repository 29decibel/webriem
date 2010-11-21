class UploadFile < ActiveRecord::Base
  has_attached_file :upload
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "p_id"
end
