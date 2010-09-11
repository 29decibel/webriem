class CpDocDetail < ActiveRecord::Base
  belongs_to :doc_head, :class_name => "DocHead", :foreign_key => "doc_head_id"
end
