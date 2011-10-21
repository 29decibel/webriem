class DocMetaInfo < ActiveRecord::Base
  has_many :doc_relations
  has_many :doc_row_meta_infos,:through => :doc_relations
  accepts_nested_attributes_for :doc_relations , :allow_destroy => true
end
