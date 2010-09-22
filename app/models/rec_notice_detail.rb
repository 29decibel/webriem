class RecNoticeDetail < ActiveRecord::Base
  belongs_to :dep
  belongs_to :project
  belongs_to :doc_head
  belongs_to :currency
end
