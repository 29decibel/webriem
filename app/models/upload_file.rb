class UploadFile < ActiveRecord::Base
  has_attached_file :upload
  belongs_to :rd_benifit, :class_name => "RdBenifit", :foreign_key => "p_id"
  cattr_reader :per_page
  @@per_page = 10
end
