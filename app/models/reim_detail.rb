class ReimDetail < ActiveRecord::Base
  belongs_to :fee
  belongs_to :dep
  belongs_to :project
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"
end
