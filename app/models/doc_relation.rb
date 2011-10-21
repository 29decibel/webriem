class DocRelation < ActiveRecord::Base
  belongs_to :doc_row_meta_info
  belongs_to :doc_meta_info
end
