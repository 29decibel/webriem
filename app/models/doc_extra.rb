class DocExtra < ActiveRecord::Base
  belongs_to :doc_head
  mount :file,DocExtraUploader
end
