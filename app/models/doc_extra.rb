class DocExtra < ActiveRecord::Base
  belongs_to :doc_head
  mount_uploader :file,DocExtraUploader
end
