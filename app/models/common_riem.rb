class CommonRiem < ActiveRecord::Base
  belongs_to :currency
  belongs_to :dep
  belongs_to :project
  belongs_to :doc_head
  belongs_to :fee
end
