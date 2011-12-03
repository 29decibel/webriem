class DocExtra < ActiveRecord::Base
  belongs_to :doc_head
  mount_uploader :file,DocExtraUploader

  validates_presence_of :file
end
