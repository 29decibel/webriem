class ReimSplitDetail < ActiveRecord::Base
  belongs_to :dep
  belongs_to :project
  belongs_to :fee
  belongs_to :doc_head
  validates_presence_of :dep_id
end
